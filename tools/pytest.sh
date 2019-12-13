#!/usr/bin/env bash
#
# run pytest with necessary settings

set -e
set -u

cd "$(dirname -- "${0}")/.."

export PYTHONPATH+=:"${PWD}"

set -x
exec python \
        -m pytest \
            --verbose \
            -c ./.config/pytest.ini \
            . \
            --cov=goto_http_redirect_server \
            --cov-config=./.config/coverage.ini \
            --cov-report=xml \
            --cov-report=html \
