#!/bin/bash
set -e

jd update

crontab /root/jd/config/crontab.list

jd panelon
jd panelon

echo -e "容器启动成功...\n"

crond -f

exec "$@"
