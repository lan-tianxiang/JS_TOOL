#!/usr/bin/env bash

dir_shell=$(dirname $(readlink -f "$0"))
dir_root=$dir_shell

cd $dir_root
git fetch --all
git reset --hard origin/A1
echo "自动修复完毕，无异常"
