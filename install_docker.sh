#!/bin/bash

# Note: the image this container is based off of doesn't include `sudo`, but anytime I've done something in the container, I was root
# Note: this image provided a wrapper around `apt` called `install_packages`, it's being used here

echo -e "Downloading dependencies to install docker..."
apt update
install_packages ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo -e "Dependencies download, certificates configured"

echo -e "Adding the Docker repository to the apt sources list"
touch /etc/apt/sources.list.d/docker.sources 
echo "Types: deb" >> /etc/apt/sources.list.d/docker.sources 
ehco "URIs: https://download.docker.com/linux/ubuntu" >> /etc/apt/sources.list.d/docker.sources  
echo "Suites: bullseye)" >> /etc/apt/sources.list.d/docker.sources 
echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources 
echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/docker.sources 
echo "Signed-By: /etc/apt/keyrings/docker.asc" >> /etc/apt/sources.list.d/docker.sources 
apt update
if [ $? -ne 0 ]; then
	echo -e "Adding to apt sources failed"
	exit 1
fi

echo -e "Installing Docker"
install_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

command -v docker
if [ $? -ne 0 ]; then
	echo "Docker not found"
	exit 1
fi

systemctl start docker

echo "Running Docker hello world"
docker run hello-world
