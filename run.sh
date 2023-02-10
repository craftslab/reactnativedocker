#!/bin/bash

NAME=craftslab/reactnativedocker
TAG=latest

docker run --rm $NAME:$TAG -e "SHELL=$SHELL" -i ./sample.sh
