* `docker info` to list the configurations of your docker.
* `docker` to list the commands of docker.

# 1. Run nginx container
* `docker container run --publish 80:80 nginx`
* `docker container run --publish 80:80 --detach nginx`
* `docker container ls`
* `docker container stop <container id>`
* `docker container ls -a`
* `docker container run --publish 80:80 --detach --name webhost nginx`
* `docker container logs <container id|container name>`
* `docker container top <container id|container name>` (use to check the processes running inside the container)
* `docker container --help` (to list the commands of docker container)
* `docker container rm <container id|container name>` (to remove the container)
* `docker container rm -f <container id|container name>` (to remove the container forcefully without stopping it)