FROM node:lts-alpine
ARG REPO=gitee
ARG REPO_URL=$REPO.com
ARG JS_TOOL_URL=https://gitee.com/highdimen/js_tool.git
ARG JS_TOOL_BRANCH=A1
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1='\u@\h:\w $ ' \
    JD_DIR=/root/jd \
    ENABLE_TG_BOT=false \
    ENABLE_WEB_PANEL=true
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk add --no-cache bash coreutils moreutils git wget curl nano perl openssh-client tzdata \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /root/.ssh \
    && ssh-keyscan $REPO_URL > /root/.ssh/known_hosts \
    && git clone -b $JS_TOOL_BRANCH $JS_TOOL_URL $JD_DIR \
    && cd ${JD_DIR}/ \
    && bash jd.sh update \
    && bash jd.sh panelon \
    && npm install -g pm2 --registry=https://registry.npm.taobao.org \
    && rm -rf /root/.npm
WORKDIR $JD_DIR
ENTRYPOINT bash $JD_DIR/docker/docker/docker-entrypoint.sh
