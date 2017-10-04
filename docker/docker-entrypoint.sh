#!/bin/bash

message() {
    echo >&2 "$*"
}

infomsg() {
    message "info: entrypoint.sh: $*"
}

infomsg "EUID=$EUID args: $*"

usage() {
    echo "Entrypoint Script"
    echo
    echo ""
    echo "$0 [options]"
    echo "options:"
    echo "      --print-env            Display environment"
    echo "      --help-entrypoint      Display this help and exit"
}

while [[ $# > 0 ]]; do
    case "$1" in
        --help-entrypoint)
            usage
            exit
            ;;
        --print-env)
            env >&2
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            break
            ;;
        *)
            break
            ;;
    esac
done

set -e
mkdir -p /var/run/supervisor /var/log/supervisor

BAIKAL_DIR=/usr/share/nginx/html/Baikal

if [[ -z "$(ls -A $BAIKAL_DIR/Specific)" && -d $BAIKAL_DIR/Specific_Initial ]]; then
    echo "Initialize $BAIKAL_DIR/Specific directory"
    cp -a "$BAIKAL_DIR/Specific_Initial"/* "$BAIKAL_DIR/Specific/"
fi
mkdir -p "$BAIKAL_DIR/Specific/db"
chown -R www-data:www-data $BAIKAL_DIR

set -x
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
