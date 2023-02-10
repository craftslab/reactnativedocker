#!/bin/bash

NAME=craftslab/reactnativedocker
TAG=latest

docker build -f Dockerfile -t $NAME:$TAG .
