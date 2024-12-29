#!/bin/bash

# Enable the "exit on error" behavior
set -e

user=dean

if [ $# -lt 2 ]; then
    echo "Please provide the Host addresses of the Nodes as arguments."
    echo "You need a ~/.ssh/config to configure ports."
    echo "./publish.sh [New Version] [api | web | both] [...IPs]"
    echo "Example: ./publish.sh v1.0 both 10.10.15.13 10.10.15.14"
    exit 1
fi

project=$(basename $(pwd))
version=$1
target=$2

# Shift two times to start loop at second argument
shift 2

echo "Project: $project"
echo "Version: $version"
echo "Target:  $target"

if [ $target == "api" ] || [ $target == "both" ]; then
    sudo docker build -t ${project}_api:${version} ./backend
    sudo docker save -o ${project}_api-${version}.tar ${project}_api:${version}
    sudo chown $(whoami):$(id -g) ${project}_api-${version}.tar
fi

if [ $target == "web" ] || [ $target == "both" ]; then
    sudo docker build -t ${project}_web:${version} ./frontend
    sudo docker save -o ${project}_web-${version}.tar ${project}_web:${version}
    sudo chown $(whoami):$(id -g) ${project}_web-${version}.tar
fi

for host in "$@"; do
    echo "[$ip] Uploading Docker Images"

    if [ $target == "api" ] || [ $target == "both" ]; then
        scp ${project}-api-${version}.tar $host:/images
        ssh $host docker load -i /images/${project}-api-${version}.tar
    fi

    if [ $target == "web" ] || [ $target == "both" ]; then
        scp ${project}-web-${version}.tar $host:/images
        ssh $host docker load -i /images/${project}-web-${version}.tar
    fi

    echo "[$ip] Done"
done
