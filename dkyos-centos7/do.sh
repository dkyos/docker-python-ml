#!/usr/bin/env bash

# Output colors
NORMAL="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"

# Names to identify images and containers of this app
IMAGE_NAME='dkyos-centos7'
CONTAINER_NAME="dkyos-centos7"

# Usefull to run commands as non-root user inside containers
USER="dongkyun.yun"
LOCAL_SRC="/Users/$USER/dkyos"
CONTAINER_SRC="/dkyos"
EXECUTE_AS="sudo -u dkyos HOME=$HOME_DIR"

log() {
    echo -e "$BLUE > $1 $NORMAL"
}

error() {
    echo ""
    echo -e "$RED >>> ERROR - $1$NORMAL"
}

build() {
    docker build -t $IMAGE_NAME .
    
    [ $? != 0 ] && \
    error "Docker image build failed !" && exit 100
}

hello() {
    log "RUN hello"
    docker run hello-world

    [ $? != 0 ] && error "failed !" && exit 101
}

run() {
    log "RUN"
    docker rm $IMAGE_NAME 
    docker run \
        --name=$IMAGE_NAME \
        -it \
        -p 8888:8888 \
        -v $LOCAL_SRC:$CONTAINER_SRC \
        $IMAGE_NAME:latest

    [ $? != 0 ] && error "Npm install failed !" && exit 101
}

bash() {
    log "BASH"
    docker exec -it $IMAGE_NAME /bin/bash
}

stop() {
    docker stop $CONTAINER_NAME
}

start() {
    docker start $CONTAINER_NAME
}

remove() {
    log "Removing previous container $CONTAINER_NAME" && \
    docker rm -f $CONTAINER_NAME &> /dev/null || true
}

help() {
    echo "--------------------"
    echo " Available commands"
    echo "--------------------"
    echo -e -n "$BLUE"
    echo "   > build - To build the Docker image"
    echo "   > run - To run the Docker image"
    echo "   > stop - To stop container"
    echo "   > start - To start container"
    echo "   > bash - Log you into container"
    echo "   > remove - Remove container"
    echo "   > help - Display this help"
    echo -e -n "$NORMAL"
    echo "------------------"
}

$*
