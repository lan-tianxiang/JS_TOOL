#!/usr/bin/env bash

dir_shell=$(dirname $(readlink -f "$0"))
dir_root=$dir_shell

cd $dir_root
git pull && echo "自动修复完毕，无异常"
