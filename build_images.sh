#!/bin/bash

# # # # # # # # # # # # # # # # # # # #
# Docker image builder for Hyperledger, Parameter-deamon, MongoDB
# Author: Siriwat K.
# Created: 4 August 2016
# # # # # # # # # # # # # # # # # # # #

echo "======== Hyperledger ========" &&
docker build -f Dockerfile_dockerclient -t stylix/hyperledger:latest . &&
docker tag stylix/hyperledger:latest hyperledger/fabric-baseimage:latest &&
echo "======== MongoDB ========" &&
docker build -f mongodb/Dockerfile_mongo -t stylix/mongo-10054:latest . &&
echo "======== Parameter-deamon ========" &&
docker build -f param_daemon/Dockerfile_param_server -t stylix/hyperledger-param:latest . &&
echo "======== Peer + Node.js ========" &&
docker build -f peer/Dockerfile_peer_nodejs -t stylix/hyperledger-peer:latest . &&
echo "======== Peer-noops + Node.js ========" &&
docker build -f peer_noops/Dockerfile_param -t stylix/hyperledger-peer:noops . &&
echo "======== Peer-pbft + Node.js ========" &&
docker build -f peer_pbft/Dockerfile_param -t stylix/hyperledger-peer:pbft . &&
echo "======== Member service ========" &&
docker build -f membersrvc/Dockerfile -t stylix/hyperledger-membersrvc .

#echo "======== Uploading ========" &&
#docker push stylix/hyperledger:latest &&
#docker push stylix/hyperledger-peer:latest &&
#docker push stylix/hyperledger-peer:noops &&
#docker push stylix/hyperledger-peer:pbft &&
#docker push stylix/hyperledger-membersrvc
