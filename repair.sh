#!/usr/bin/env bash

## Author: lan-tianxiang
## Source: https://github.com/lan-tianxiang/js_tool
## Modified： 2021-03-27
## Version： v0.0.2

dir_shell=$(dirname $(readlink -f "$0"))
dir_root=$dir_shell
dir_config=$dir_root/config
file_cookie=$dir_config/cookie.sh
[ -f /proc/1/cgroup ] && [[ -n $(cat /proc/1/cgroup | grep cpuset | grep scope) ]] && echo "docker无法使用此命令，抱歉" && exit 0
[ -s $file_cookie ] && cp $file_cookie $(dirname $dir_shell)/cookie.sh && echo "备份cookie成功"
pkill -9 node
bash $dir_shell/jd.sh paneloff
crontab -r
rm -rf $dir_shell
cd $(dirname $dir_shell)

function REINSTALLATION() {
  echo -e "\n1. 获取源码"

  git clone https://gitee.com/highdimen/js_tool.git $dir_shell

  echo -e "\n2. 还原配置文件"
  mkdir -p $dir_config
  [ -f $(dirname $dir_shell)/cookie.sh ] && cp -rf $(dirname $dir_shell)/cookie.sh $file_cookie && rm -rf $(dirname $dir_shell)/cookie.sh && echo "还原配置文件成功"
  [ ! -f $dir_shell/config/config.sh ] && cp -f $dir_shell/sample/config.sh.sample $dir_shell/config/config.sh
  [ ! -f $dir_shell/config/cookie.sh ] && cp -f $dir_shell/sample/cookie.sh.sample $dir_shell/config/cookie.sh
  [ ! -f $dir_shell/config/crontab.list ] && cp -f $$dir_shell/sample/crontab.list.sample $dir_shell/config/crontab.list
  [ ! -f $dir_shell/config/sharecode.sh ] && cp -f $dir_shell/sample/sharecode.sh.sample $dir_shell/config/sharecode.sh

  echo -e "\n3. 执行脚本更新以及定时文件更新"
  npm config set registry https://registry.npm.taobao.org
  bash $dir_shell/jd.sh update

  echo -e "\n修复完成！！！！"
}

REINSTALLATION
