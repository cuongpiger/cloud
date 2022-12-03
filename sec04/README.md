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

# 2. Run **MongoDB** inside docker container
```bash
docker run --name mongo -d mongo
```
* Then run the below command to list the process
```bash
docker top mongo
```

* Use the command below to see all the process running on your host.
```bash
ps aux
```

* Ise the command below to list process which match with filter
```bash
ps aux | grep mongo
```