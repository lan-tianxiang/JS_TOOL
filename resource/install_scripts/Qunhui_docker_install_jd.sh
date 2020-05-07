#!/usr/bin/env bash
#
# 以 Docker 容器的方式一键安装 jd-base。
#
clear

DockerImage="lantianxiang1/js_tool:A1"
ShellName=$0
ShellDir=$(cd "$(dirname "$0")";pwd)
ContainerName=""
PanelPort=""
WorkDir="${ShellDir}/jd-docker-workdir"
JdDir=""
ConfigDir=""
LogDir=""
ScriptsDir=""

GetImageType="Online"
HasImage=false
NewImage=true
DelContainer=false

NeedDirConfig=""
NeedDirLog=""
NeedDirScripts=""

log() {
    echo -e "\e[32m$1 \e[0m"
}

inp() {
    echo -e "\e[33m$1 \e[0m"
}

warn() {
    echo -e "\e[31m$1 \e[0m"
}

HasImage=true
DelContainer=true
ContainerName="jd"
PanelPort="5678"
NeedDirConfig=''
NeedDirLog=''

#
# 配置信息收集完成，开始安装
#

if [ $NewImage = true ]; then
    log "\n正在获取新镜像..."
    if [ $HasImage = true ]; then
        docker stop jd
        docker rm jd
        docker rmi $(docker images lantianxiang1/js_tool -q)
    fi
    if [ $GetImageType = "Local" ]; then
        rm -rf $WorkDir
        mkdir -p $WorkDir
        wget -q https://gitee.com/highdimen/js_tool/raw/A1/docker/docker/Dockerfile -O $WorkDir/Dockerfile
        sed -i 's,github.com,github.com.cnpmjs.org,g' $WorkDir/Dockerfile
        sed -i 's,npm install,npm install --registry=https://registry.npm.taobao.org,g' $WorkDir/Dockerfile
        docker build -t $DockerImage $WorkDir > $ShellDir/build_jd_image.log
        rm -fr $WorkDir
    else
        docker pull $DockerImage
    fi
fi

if [ $DelContainer = true ]; then
    log "\n2.2.删除先前的容器"
    docker stop $ContainerName > /dev/null
    docker rm $ContainerName > /dev/null
fi

clear

log "\n创建容器并运行"
docker run -dit \
    $NeedDirConfig \
    $NeedDirLog \
    $NeedDirScripts \
    -p $PanelPort:5678 \
    --name $ContainerName \
    --hostname jd \
    --restart always \
    $DockerImage

log "\n下面列出所有容器"
docker ps

log "\n安装已经完成。\n请访问 http://<ip>:${PanelPort} 进行配置\n初始用户名：admin，初始密码：adminadmin"
rm -f $ShellDir/$ShellName
echo "进入容器命令为########docker exec -it jd /bin/bash"
