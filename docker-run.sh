#!/bin/bash

THIS_DIR="$(dirname "$( readlink -f "${0}" 2>/dev/null || \
  python -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "${0}" )")"

cd "$THIS_DIR"

docker run --name "calendar" --privileged=true -h calendar \
       --volume "$PWD/data:/usr/share/nginx/html/Baikal/Specific:Z" \
       -e CONTAINER_DOMAIN_NAME=container.local -p 8800:80 --rm -ti baikal-caldav
