# Forked from https://github.com/yeasy/docker-hyperledger

# Dockerfile for Hyperledger base image, with everything (peer, membersrvc) to go!
# If you need a peer node to run, please see the yeasy/hyperledger-peer image.
# Workdir is set to $GOPATH.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

# Under $GOPATH/bin, there are 2 config files: 
# core.yaml for peer
# membersrvc.yaml for mermber service

FROM golang:1.6

MAINTAINER Siriwat K.

ENV DEBIAN_FRONTEND noninteractive

# Proxy
ENV all_proxy 'socks://10.136.0.56:8080'
ENV http_proxy 'http://10.136.0.56:8080'
ENV https_proxy 'https://10.136.0.56:8080'

COPY ./environment /etc/
COPY ./95proxies /etc/apt/apt.conf.d/

RUN apt-get update \
        && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev \
        && rm -rf /var/cache/apt

# install rocksdb
RUN cd /tmp \
        && git clone --single-branch -b v4.1 --depth 1 https://github.com/facebook/rocksdb.git \
        && cd rocksdb \
        && PORTABLE=1 make shared_lib \
        && INSTALL_PATH=/usr/local make install-shared \
        && ldconfig \
        && cd / \
        && rm -rf /tmp/rocksdb

RUN mkdir -p /var/hyperledger/db \
        && mkdir -p /var/hyperledger/production

# install hyperledger
RUN mkdir -p $GOPATH/src/github.com/hyperledger \
        && cd $GOPATH/src/github.com/hyperledger \
        && git clone --single-branch -b master --depth 1 https://github.com/hyperledger/fabric.git \
        && cd $GOPATH/src/github.com/hyperledger/fabric/peer \
        && CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install \
        && go clean \
        && cd $GOPATH/src/github.com/hyperledger/fabric/membersrvc \
        && CGO_CFLAGS=" " CGO_LDFLAGS="-lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy" go install \
        && go clean \
        && cp $GOPATH/src/github.com/hyperledger/fabric/devenv/limits.conf /etc/security/limits.conf

# this is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath

# this is to keep compatible
RUN PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:$PATH

WORKDIR $GOPATH/src/github.com/hyperledger/fabric