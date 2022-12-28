
# Section 4. Creating and Using Containers like a Boss
## 1. Check Our Docker Install and Config
|Commands|Description|
|-|-|
|`docker version`|Check your versions and that docker is working.|
|`docker info`|Give some information, such as amount of containers is running, paused, or stopped,... amount of images|
|`docker`|Get the guidelines of commands, flags,... in docker|

### 1.1. Brief
* Check version of our docker CLI and engine.
* Create an **Nginx** (web server) container.
* Learn common container management commands.
* Learn Docker networking basics.

### 1.2. Notes
* There is two style to run commands in docker:
  * [old style] `docker <command> (options)`
  * [new style] `docker <command> <subcommand> (options)`

<hr>

## 2. Starting a Nginx Web Server
|Commands|Description|
|-|-|
|`docker container run --publish 80:80 nginx`|Run **Nginx** server on port **80** of host machine.|
|`docker container run --publish 80:80 --detach nginx`|Run **Nginx** server on port **80** of host machine in the background.|
|`docker container ls`|List all the running containers.|
|`docker container stop <container-id>`|Stop contaner which have ID `<container-id>`.|
|`docker container ls -a`|Get all the containers in host machine *(include of **running**, **stopped**, or **exited**)*.|
|`docker container run --publish 80:80 --detach --name webhost nginx`|Run **Nginx** server and named it `webhost` on port 80 of host machine.|
|`docker container logs webhost`|Show the logs of container `webhost`.|
|`docker container top webhost`|List all processes that are running inside container `webhost`.|
|`docker container --help`|Get all the **sub-commands** that docker support for the `command`, such as: `kill`, `logs`, etc...|
|`docker container rm <container-id 1> <container-id 2>`|Remove `<container-id 1>` and `<container-id 2>` out of the docker on host machine. **Note**: _you can not remove running containers_.|
|`docker container rm -f <container-id 1> <container-id 2>`|Remove `<container-id 1>` and `<container-id 2>` neither **running** nor **stopped**, **exited** out of the docker on host machine|
### 2.1. Brief
* **Images** vs **Container**
* `run`/`stop`/`remove` containers.
* Check container logs and processes.

### 2.2. Notes
* **Important**: if using **Docker Toolbox**, type the IP Address `http://192.168.99.100`.
* Docker's default image **registry** is **Docker Hub** _[https://hub.docker.com](https://hub.docker.com)_.
