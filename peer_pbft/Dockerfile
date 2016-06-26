# Forked from https://github.com/yeasy/docker-hyperledger-peer:pbft

# Dockerfile for Hyperledger peer image with consensus pbft. This follows hyperledger
# image and update the consensus config file.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM stylix/hyperledger:latest
MAINTAINER Siriwat K.

RUN cp $GOPATH/src/github.com/hyperledger/fabric/consensus/obcpbft/config.yaml $GOPATH/bin

CMD ["peer","node","start"]