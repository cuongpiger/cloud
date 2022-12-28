
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

## 2. Starting a Nginx Web Server
|Commands|Description|
|-|-|
|`docker container run --publish 80:80 nginx`|Run **Nginx** server on port **80** of host machine.|
|`docker container run --publish 80:80 --detach nginx`|Run **Nginx** server on port **80** of host machine in the background.|
|`docker container ls`|List all the running containers.|
|`docker container stop <container-id>`|Stop contaner which have ID `<container-id>`.|
|`docker container ls -a`|Get all the containers in host machine *(neither running nor stopped)*.|
### 2.1. Brief
* **Images** vs **Container**
* `run`/`stop`/`remove` containers.
* Check container logs and processes.

### 2.2. Notes
* **Important**: if using **Docker Toolbox**, type the IP Address `http://192.168.99.100`.
* Docker's default image **registry** is **Docker Hub** _[https://hub.docker.com](https://hub.docker.com)_.
* 

neither 