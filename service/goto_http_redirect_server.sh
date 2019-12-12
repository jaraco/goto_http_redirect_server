#!/usr/bin/env bash
#
# systemd wrapper for goto_http_redirect_server.service
#
# Options may be adjusted via command-line or configuration file.
# Configuration file is defaults to /etc/goto_http_redirect_server.conf.
# Remaining unprocessed command-line options are passed to
# goto_http_redirect_server
#

set -u
set -e
set -x

# if available, load configuration file
GOTO_CONF=${GOTO_CONF-/etc/goto_http_redirect_server.conf}
if [ -f "${GOTO_CONF}" ]; then
    source "${GOTO_CONF}"
else
    echo "NOTE: configuration file '${GOTO_CONF}' was not found" >&2
fi

authbind=
if ${GOTO_AUTHBIND_ENABLE-false} &>/dev/null; then
    authbind='authbind --deep'
fi
sudoas=
if ${GOTO_SUDOAS_ENABLE-false} &>/dev/null; then
    sudoas="sudo -u ${GOTO_SUDOAS_USER} --"
fi
nice=
if ${GOTO_NICE_ENABLE-false} &>/dev/null; then
    nice="nice -n ${GOTO_NICE_LEVEL}"
fi

declare -a argv=("${@}")  # pass `getopts` a copy of args to allow `shift`s
while getopts "au:n:p:dh?" opt "${argv[@]:-}"; do
    case ${opt} in
        a)
            authbind='authbind --deep'
            shift;
            ;;
        u)
            sudoas="sudo -u ${OPTARG} --"
            shift;
            shift;
            ;;
        n)
            nice="nice -n ${OPTARG}"
            shift;
            shift;
            ;;
        h)
            ;&
        \?)
            (
                echo "Invokes goto_http_redirect_server with optional process adjustments."
                echo
                echo "Usage: ${0} [-a] [-u USER] [-n NICE] [-p PORT] [-d] …"                
                echo
                echo "       -a  lower privilege using 'authbind --deep' (requires authbind)"
                echo "       -u  run process using 'sudo -u USER'  (requires sudo)"
                echo "       -n  run process with nice level NICE"
                echo "       … remaining unprocessed arguments are passed directly to goto_http_redirect_server"
                echo
                echo "This script imports other settings from /etc/goto_http_redirect_server.conf"
                echo
                echo "Usage: ${0} [-h] [-?]"
                echo
                echo "       This help message"
            ) >&2
            exit 4
            ;;
    esac
done

# append remaining arguments to array GOTO_ARGV
if ! declare -p GOTO_ARGV &>/dev/null; then
    GOTO_ARGV=("${@}")
else
    GOTO_ARGV+=("${@}")
fi
GOTO_FILE_SCRIPT=${GOTO_FILE_SCRIPT:-/usr/local/bin/goto_http_redirect_server}
GOTO_FILE_REDIRECTS=${GOTO_FILE_REDIRECTS:-/usr/local/share/goto_http_redirect_server.csv}
GOTO_FILE_LOG=${GOTO_FILE_LOG-/var/log/goto_http_redirect_server.log}

(declare -p | sort | grep 'GOTO_') || true
set -x
exec \
    ${sudoas} \
        ${authbind} \
            ${nice} \
                ${GOTO_FILE_SCRIPT} \
                    --redirects "${GOTO_FILE_REDIRECTS}" \
                    --log "${GOTO_FILE_LOG}" \
                    "${GOTO_ARGV[@]}"
