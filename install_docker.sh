#!/bin/bash

# Note: the image this container is based off of doesn't include `sudo`, but anytime I've done something in the container, I was root
# Note: this image provided a wrapper around `apt` called `install_packages`, it's being used here

echo -e "Downloading dependencies to install docker..."
install_packages ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo -e "Dependencies download, certificates configured"

echo -e "Adding the Docker repository to the apt sources list"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable" | \
	/etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

if [ $? -ne 0 ]
	echo -e "Adding to apt sources failed"
	exit 1
fi

echo -e "Installing Docker"
install_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
