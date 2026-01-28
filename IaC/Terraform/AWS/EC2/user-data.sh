#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

docker pull ${docker_image}
docker run -d -p 80:80 --restart always ${docker_image}
