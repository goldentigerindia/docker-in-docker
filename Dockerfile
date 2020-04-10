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
    git \
    man \
    wget \
    build-essential && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://get.docker.com/ | sh
VOLUME /var/lib/docker
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
RUN /root/.scripts/install_env.sh
ENV IS_DOCKER "$(cat /app/is_docker)"
ENV ENVIRONMENT_NAME "$(cat /app/environment_name)"
ENV BUILD_BRANCH "$(cat /app/build_branch)"
RUN mkdir -p /root/go/src/github.com/goldentigerindia
RUN mkdir -p /root/go/bin
RUN cp /root/.scripts/wrapdocker /app/wrapdocker
RUN chmod 777 -R /app/
WORKDIR /app
ENTRYPOINT ["./wrapdocker"]
EXPOSE 8443


