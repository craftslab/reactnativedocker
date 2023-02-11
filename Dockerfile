FROM ubuntu:20.04

USER root
ARG GID=1000
ARG UID=1000
ARG LANG_EN="en_US.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt update -y && \
    apt install -y build-essential curl ethtool file git locales lsof m4 make net-tools && \
    apt install -y openjdk-11-jdk patch python3 python3-pip software-properties-common && \
    apt install -y sudo unzip upx vim wget zip
RUN apt autoremove --purge -y > /dev/null && \
    apt autoclean -y > /dev/null && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/log/* && \
    rm -rf /tmp/*
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    echo "LC_ALL=$LANG_EN" >> /etc/environment && \
    echo "LANG=$LANG_EN" > /etc/locale.conf && \
    echo "$LANG_EN UTF-8" >> /etc/locale.gen && \
    echo "StrictHostKeyChecking no" | tee --append /etc/ssh/ssh_config && \
    echo "ulimit -n 4096" | tee --append /etc/profile && \
    echo "ulimit -s 102400" | tee --append /etc/profile && \
    echo "craftslab ALL=(ALL) NOPASSWD: ALL" | tee --append /etc/sudoers && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    groupadd -g $GID craftslab && \
    useradd -d /home/craftslab -ms /bin/bash -g craftslab -u $UID craftslab
RUN locale-gen $LANG_EN && \
    update-locale LC_ALL=$LANG_EN LANG=$LANG_EN
ENV LANG=$LANG_EN
ENV LC_ALL=$LANG_EN
ENV SHELL="/bin/bash"

USER craftslab
WORKDIR /home/craftslab
ARG ANDROID=/home/craftslab/android
RUN curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o commandlinetools.zip && \
    mkdir -p $ANDROID; unzip commandlinetools.zip -d $ANDROID > /dev/null && \
    rm -f *.zip
ENV ANDROID_HOME=$ANDROID
ENV PATH=$ANDROID/cmdline-tools/bin:$ANDROID/platform-tools:$ANDROID/tools/bin:$PATH
RUN mkdir $HOME/.android; echo "count=0" > $HOME/.android/repositories.cfg && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "build-tools;31.0.0" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "cmdline-tools;latest" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "extras;android;m2repository" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "extras;google;m2repository" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "platforms;android-31" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME "tools" > /dev/null && \
    yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses > /dev/null
RUN curl -LO https://nodejs.org/download/release/v18.13.0/node-v18.13.0-linux-x64.tar.xz && \
    tar Jxvf node*.tar.xz && \
    rm node*.tar.xz && \
    mv node-* node
ENV PATH=/home/craftslab/node/bin:$PATH
RUN curl -LO https://services.gradle.org/distributions/gradle-7.5.1-all.zip && \
    unzip gradle*.zip && \
    rm gradle*.zip && \
    mv gradle-* gradle
ENV PATH=/home/craftslab/gradle/bin:$PATH
