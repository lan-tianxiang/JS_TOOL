FROM node:lts-alpine
LABEL maintainer="Highdimen"
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
WORKDIR $JD_DIR
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk add --no-cache bash coreutils moreutils nano git wget curl tzdata perl openssh-client python3 jq \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /root/.ssh \
    && ssh-keyscan $REPO_URL > /root/.ssh/known_hosts \
    && git clone -b $JS_TOOL_BRANCH $JS_TOOL_URL $JD_DIR \
    && git config --global user.email "lan-tianxiang@@users.noreply.github.com" \
    && git config --global user.name "lan-tianxiang" \
    && git config --global pull.rebase true \
    && chmod -R 777 ${JD_DIR}/ \
    && cd ${JD_DIR}/ \
    && npm install -g pnpm \
    && pnpm config set registry http://registry.npm.taobao.org \
    && pnpm install -g pm2 \
    && pnpm install -g ts-node typescript tslib \
    && ln -sf $JD_DIR/jd.sh /usr/local/bin/jd \
    && jd update \
    && jd update \
    && jd panelon \
    && rm -rf /root/.npm
ENTRYPOINT bash $JD_DIR/docker/docker/docker-entrypoint.sh
