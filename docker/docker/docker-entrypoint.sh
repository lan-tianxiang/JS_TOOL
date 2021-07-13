#!/bin/bash
set -e

echo -e "\n======================== 2. 更新源代码 ========================\n"
jd update
echo

crontab /root/jd/config/crontab.list

jd panelon

echo -e "容器启动成功...\n"

crond -f

exec "$@"
