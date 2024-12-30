#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Please provide the Host address of the Control Plane Node as argument."
    echo "You need a ~/.ssh/config to configure ports."
    echo "./publish.sh [New Version] [Optional: api | web]"
    echo "Example: ./publish.sh 1.0 192.110.10.24 api"
    exit 1
fi

project=$(basename $(pwd))
version=$1
target=both

if [ $# -ge 2 ]; then
    target=$2
fi

echo "Project:     $project"
echo "Version:     $version"
echo "Target:      $target"
echo "Registry IP: $(getent hosts registry.internal)"

function upload {
    target_resolved=$1
    target_folder=$2

    image_name=registry.internal:5000/${project}_${target_resolved}:${version}
    tar_name=${project}_${target_resolved}-${version}.tar

    echo "----------------- Building ${target_resolved} -----------------"

    sudo docker build -t $image_name $target_folder
    sudo docker push $image_name
}

if [ $target == "api" ]; then
    upload api ./backend
elif [ $target == "web" ]; then
    upload web ./frontend
elif [ $target == "both" ]; then
    upload api ./backend
    upload web ./frontend
fi
