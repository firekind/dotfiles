#!/bin/bash

set -eo pipefail

FILE=$1

if [[ -z $FILE ]]; then
    echo "Path to the containerfile / dockerfile is not provided"
    exit 1
fi

if [[ ! -f $FILE ]]; then
    echo "file '$FILE' does not exist"
    exit 1
fi

TAG="${FILE%%.*}"

docker build --push -f $FILE -t firekind/distroboxes:$TAG .
