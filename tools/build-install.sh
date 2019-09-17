#!/usr/bin/env bash
#
# uninstall, build, install, run
#

set -e
set -u
set -o pipefail

cd "$(dirname -- "${0}")/.."  # cd to project top-level

#
# make a good effort to get the path to the local python 3 installation
# if $PTYHON is set, assume it's the PYTHON interpreter
#
if [[ ! "${PYTHON+x}" ]]; then
    # attempt to set python to most portable invocation
    PYTHON='python'  # fallback
    if which 'python3' &> /dev/null; then
        PYTHON='python3'  # Linux Python 3
    elif which 'py' &> /dev/null; then
        PYTHON='py -3'  # Windows launcher
    fi
fi

# check $PYTHON runs
${PYTHON} --version

#
# build package
#

readonly PACKAGE_NAME='goto_http_redirect_server'
readonly PROGRAM_NAME='goto_http_redirect_server'

# Debian bash on Windows Linux Subsystem may not have default pip install path
if [[ -d ~/.local/bin ]]; then
    export PATH=${PATH}:~/.local/bin
fi

set -x

${PYTHON} -m pip list -vvv

# uninstall any previous install (must be done outside the project directory)
cd ..

${PYTHON} -m pip uninstall --yes --verbose "${PACKAGE_NAME}" || true

# remove previous build artifacts
rm -rfv ./build/ ./dist/ "./${PACKAGE_NAME}.egg-info/"

# build using wheels
cd -
version=$(${PYTHON} -B -c 'from goto_http_redirect_server import goto_http_redirect_server as gh;print(gh.__version__)')
usersite=$(${PYTHON} -B -c 'import site; print(site.USER_SITE);')  # pip may install to here
userscripts="${usersite}/../Scripts"   # pip in minGW bash may install to here
userbase=$(${PYTHON} -B -c 'import site; print(site.USER_BASE);')  # pip may install to here
export PATH="${PATH}:${usersite}:${userscripts}:${userbase}"

${PYTHON} setup.py -v bdist_wheel

# note the contents of dist
ls -l ./dist/

set +x
# get the full path to the wheel file
# (usually, `basename $PWD` is 'goto_http_redirect_server' but on circleci it's 'project')
cv_whl=$(readlink -f -- "./dist/${PACKAGE_NAME}-${version}-py3-none-any.whl") || true
if ! [[ -f "${cv_whl}" ]]; then
    cv_whl=$(readlink -f -- "./dist/${PACKAGE_NAME}-${version}-py3.7-none-any.whl") || true
fi
if ! [[ -f "${cv_whl}" ]]; then
    echo "ERROR: could not find expected wheel file at './dist/${PACKAGE_NAME}-${version}-py3-none-any.whl'" >&2
    exit 1
fi

(
    set -x
    ${PYTHON} -m twine --version
    ${PYTHON} -m twine check "${cv_whl}"
)

# install the wheel (must be done outside the project directory)
(   
    cd ..
    user_arg=--user
    if [[ "${VIRTUAL_ENV+x}" ]]; then  # if virtualenv then do not pass --user
        user_arg=''
    fi
    set -x
    ${PYTHON} -m pip install ${user_arg} --verbose "${cv_whl}"
)

# make sure to attempt uninstall if asked
uninstall=false
if [[ "${1+x}" == '--uninstall' ]]; then
    uninstall=true
fi
function on_exit(){
    if ${uninstall}; then
      set -x
      ${PYTHON} -m pip uninstall --yes --verbose "${PACKAGE_NAME}"
    fi
}
trap on_exit EXIT

PORT=55923  # hopefully not in-use!
(
    set -x
    # does it run?
    "${PACKAGE_NAME}" --version
    # does it run and listen on the socket?
    "${PACKAGE_NAME}" --debug --shutdown 2 --port ${PORT} --from-to '/a' 'http://foo.com'
)

#
# exit with hint
#

if ${uninstall}; then
    # and test uninstall if asked
    (
        set -x
        ${PYTHON} -m pip uninstall --yes --verbose "${PACKAGE_NAME}"
    )
    # if script got here then no need to run uninstall on EXIT
    uninstall=false
else
    echo "
To uninstall remaining package:

        (cd ..; ${PYTHON} -m pip uninstall --yes --verbose '${PACKAGE_NAME}')

or run this script with '--uninstall'
"
fi

echo "Success!

To upload to pypi:

    ${PYTHON} -m twine upload --verbose '${cv_whl}'
"
