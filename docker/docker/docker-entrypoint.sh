#!/bin/bash
set -e

crond

echo -e "\n======================== 2. 更新源代码 ========================\n"
jd update
echo

crontab /root/jd/config/crontab.list

jd panelon
jd panelon

echo -e "容器启动成功...\n"

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
