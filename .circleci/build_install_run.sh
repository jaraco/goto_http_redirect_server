#!/usr/bin/env bash
# for CircleCI job build_install_run

set -e
set -u
set -o pipefail

BUILD_INSTALL="$(dirname -- "${0}")/../tools/build-install.sh"
set -x
whoami
pwd
env | sort
ls -la .
uname -a
python --version
pip --version
pip install --user twine
chmod +x "${BUILD_INSTALL}"  # force +x
"${BUILD_INSTALL}" --uninstall
