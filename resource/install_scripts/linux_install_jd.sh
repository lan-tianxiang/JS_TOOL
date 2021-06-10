#!/usr/bin/env bash
clear
echo -e "\n"
echo -e "\n开始部署jd_shell\n"

ShellName=$0
dir_shell=$(dirname $(readlink -f "$0"))
JdDir=$dir_shell/jd

## 判断使用系统
detect_system() {
  SYSTEM=UnKnow
  [[ -n $(uname -a | grep Android) ]] && SYSTEM=Android
  [[ -n $(uname -s | grep Darwin) ]] && SYSTEM=Macos
  [[ -n $(ls /etc | grep lsb-release) ]] && SYSTEM=Ubuntu
  [[ -n $(ls /etc | grep debian_version) ]] && SYSTEM=Debian
  [[ -n $(ls /etc | grep redhat-release) ]] && SYSTEM=Centos
  [ -s /proc/1/cgroup ] && [[ -n $(cat /proc/1/cgroup | grep cpuset | grep scope) ]] && SYSTEM=Docker
  [ -s /proc/version ] && [[ -n $(cat /proc/version | grep Openwar) ]] && SYSTEM=Openwar
}

Welcome() {
  echo -e '#####################################################'
  echo -e "\n正在为您安装环境（依赖）：\ngit wget curl perl moreutils node.js yarn/npm\n"
  echo -e '#####################################################'
  echo -e "除了安卓，由于其它系统安装软件可能需要使用sudo，本脚本除安装环境外不会调用再次任何root的执行权限\n"
  echo -e "若担心安全风险，可选择自行安装环境!!\n"
  echo -e '#####################################################'
  echo -e "检测到系统似乎为 $SYSTEM ,请输入你的系统对应序号 :\n"
  echo -e "1   debian/ubuntu/armbian/OpenMediaVault，以及其他debian系\n"
  echo -e "2   CentOS/RedHat/Fedora等红帽系\n"
  echo -e "3   Termux为主的安卓系\n"
  echo -e "4   环境已安装，直接开始部署脚本\n"
  echo -e "5   自己手动安装环境(退出)\n"
  echo -e "时间$(date +%Y-%m-%d) $(date +%H:%M)"
  echo -e ''
  echo -e '#####################################################'
  echo -e ''
  read -n1 LINUX_TYPE
  case $LINUX_TYPE in
  1)
    echo "   debian/ubuntu/armbian/OpenMediaVault，以及其他debian系"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y git wget curl perl yarn npm
    if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
      echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
      exit 1
    else
      echo -e "\n依赖安装完成,开始部署脚本，否则按 Ctrl + C 退出！\n"
      INSTALLATION_CLONE
      TG_BOT
    fi
    ;;
  2)
    echo "   CentOS/RedHat/Fedora等红帽系"
    curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    sudo yum -y update && sudo yum -y install git wget curl perl yarn npm
    if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
      echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
      exit 1
    else
      echo -e "\n依赖安装完成,开始部署脚本，否则按 Ctrl + C 退出！\n"
      INSTALLATION_CLONE
      TG_BOT
    fi
    ;;
  3)
    echo "   Termux为主的安卓系"
    pkg update -y && pkg install -y git perl nodejs-lts yarn wget curl nano cronie
    if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
      echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
      exit 1
    else
      echo -e "\n依赖安装完成,开始部署脚本，否则按 Ctrl + C 退出！\n"
      INSTALLATION_CLONE
      TG_BOT
    fi
    ;;
  4)
    echo "   已安装(继续)"
    if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
      echo -e "\n依赖未安装完整！\n"
      exit 1
    else
      echo -e "\n依赖已安装,开始部署脚本，否则按 Ctrl + C 退出！\n"
      INSTALLATION_CLONE
      TG_BOT
    fi
    ;;
  *)
    echo "   自己手动安装环境(退出)"
    ;;
  esac
}

INSTALLATION_CLONE() {
  echo -e "\n1. 获取源码"
  [ -d $JdDir ] && mv $JdDir $JdDir.bak && echo "检测到已有 $JdDir 目录，已备份为 $JdDir.bak"
  git clone -b A1 https://gitee.com/highdimen/js_tool.git $JdDir

  echo -e "\n2. 配置文件"
  crontab -l >$JdDir/old_crontab
  npm config set registry https://registry.npm.taobao.org
  echo -e "\n3. 执行 git_pull.sh 进行脚本更新以及定时文件更新"
  mkdir $JdDir/config
  [ ! -f $JdDir/config/config.sh ] && cp -f $JdDir/sample/config.sh.sample $JdDir/config/config.sh
  [ ! -f $JdDir/config/cookie.sh ] && cp -f $JdDir/sample/cookie.sh.sample $JdDir/config/cookie.sh
  [ ! -f $JdDir/config/crontab.list ] && cp -f $JdDir/sample/crontab.list.sample $JdDir/config/crontab.list
  [ ! -f $JdDir/config/sharecode.sh ] && cp -f $JdDir/sample/sharecode.sh.sample $JdDir/config/sharecode.sh
  bash $JdDir/jd.sh update

  echo -e "\n注意：原有定时任务已备份在 $JdDir/old_crontab"
  rm -f $dir_shell/${ShellName}

  echo -e "\n安装完成！！！！"
}

TG_BOT() {
  echo -e "\n 是否启用TG机器人功能，需额外占据200mb左右的空间，可能出现占用较大运行内存，cpu资源加重等情况"
  echo -e "\n 任意键暂不启用，后续仍可以开启。输入 1 现在开启。"
  read -n1 PY_TYPE
  case $PY_TYPE in
  1)
    case $LINUX_TYPE in
    1)
      sudo apt install -y python3 gcc
      ;;
    2)
      sudo yum install -y python3 gcc
      ;;
    3)
      pkg install -y python3 gcc
      ;;
    esac
    ;;
  *)
    exit 0
    ;;
  esac
}
detect_system
Welcome
