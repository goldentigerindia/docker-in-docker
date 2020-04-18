FROM ubuntu:16.04
USER root
#Install
#Lets start with some basic stuff
RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" >> /etc/apt/sources.list && \
    apt-get update  && apt-get upgrade -y && apt-get install -y \
    ca-certificates \
    curl \
    lxc \
    iptables \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    zip \
    unzip \
    curl \
    gnupg \ 
    htop \
    man \
    wget \
    build-essential && \
    rm -rf /var/lib/apt/lists/*
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4052245BD4284CDD && \
    echo "deb https://repo.iovisor.org/apt/$(lsb_release -cs) $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/iovisor.list
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update -y && apt-get -y install bcc-tools libbcc-examples  docker-ce docker-ce-cli containerd.io linux-headers-generic
ADD root/scripts /root/.scripts
RUN chmod 777 -R /root/.scripts
WORKDIR /root/
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz
RUN tar -xvf docker-19.03.8.tgz
RUN cp docker/* /usr/bin/
RUN wget https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz
RUN tar -xvf go1.13.9.linux-amd64.tar.gz
RUN mv go /usr/local/
ENV GOARCH amd64
ENV GOOS linux
ENV PKG_CONFIG_PATH /root
ENV GOROOT /usr/local/go
ENV GOBIN "$GOROOT/bin"
ENV GOPATH "$HOME/go"
ENV PATH "$GOBIN:$GOROOT/bin:$PATH:/root/bin"
RUN mkdir /app
ARG ENVIRONMENT_NAME
ENV ENVIRONMENT_NAME=$ENVIRONMENT_NAME
ARG BUILD_BRANCH
ENV BUILD_BRANCH=$BUILD_BRANCH
RUN /root/.scripts/install_env.sh
RUN mkdir -p /root/go/src/github.com/goldentigerindia
RUN mkdir -p /root/go/bin
RUN cp /root/.scripts/start.sh /app/start.sh
RUN chmod 777 -R /app/
WORKDIR /app
RUN git clone --depth 1 https://github.com/brendangregg/FlameGraph && \
    git clone --depth 1 https://github.com/iovisor/bcc
ENTRYPOINT ["/app/start.sh"]
EXPOSE 8443


