FROM node:lts-alpine
ARG REPO=gitee
ARG REPO_URL=$REPO.com
ARG JD_SHELL=jd_shell
ARG JD_SHELL_BRANCH=master
ARG JD_SHELL_HOST=jd_shell_$REPO
ARG JD_SCRIPTS=jd_scripts
ARG JD_SCRIPTS_BRANCH=master
ARG JD_SCRIPTS_HOST=jd_scripts_$REPO
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1='\u@\h:\w $ ' \
    JD_DIR=/jd \
    ENABLE_TG_BOT=false \
    ENABLE_HANGUP=false \
    ENABLE_RESET_REPO_URL=true \
    JD_SHELL_URL=git@$JD_SHELL_HOST:highdimen/$JD_SHELL.git \
    JD_SCRIPTS_URL=git@$JD_SCRIPTS_HOST:highdimen/$JD_SCRIPTS.git
WORKDIR $JD_DIR
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
                             coreutils \
                             git \
                             wget \
                             curl \
                             nano \
                             tzdata \
                             perl \
                             openssh-client \
                             python3 \
                             zlib-dev \
                             gcc \
                             jpeg-dev \
                             python3-dev \
                             musl-dev \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && mkdir -p /root/.ssh \
    && echo -e $JD_SHELL_KEY > /root/.ssh/$JD_SHELL \
    && echo -e $JD_SCRIPTS_KEY > /root/.ssh/$JD_SCRIPTS \
    && chmod 600 /root/.ssh/$JD_SHELL /root/.ssh/$JD_SCRIPTS \
    && echo -e "Host $JD_SHELL_HOST\n\tHostname $REPO_URL\n\tIdentityFile=/root/.ssh/$JD_SHELL\n\nHost $JD_SCRIPTS_HOST\n\tHostname $REPO_URL\n\tIdentityFile=/root/.ssh/$JD_SCRIPTS" > /root/.ssh/config \
    && echo -e "\n\nHost *\n  StrictHostKeyChecking no\n" >> /etc/ssh/ssh_config \
    && chmod 644 /root/.ssh/config \
    && ssh-keyscan $REPO_URL > /root/.ssh/known_hosts \
    && git clone -b $JD_SHELL_BRANCH $JD_SHELL_URL $JD_DIR \
    && git clone -b $JD_SCRIPTS_BRANCH $JD_SCRIPTS_URL $JD_DIR/scripts \
    && cd $JD_DIR/scripts \
    && npm install \
    && npm install -g pm2 \
    && ln -sf $JD_DIR/jd.sh /usr/local/bin/jd \
    && cp -f $JD_DIR/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
    && chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && chmod 777 $JD_DIR/*.sh \
    && rm -rf /root/.npm \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && cd $JD_DIR/bot \
    && pip3 install -r requirements.txt
ENTRYPOINT bash $JD_DIR/docker/docker-bot/docker-entrypoint.sh