**Resources**:
* **Source code** [https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide](https://github.com/PacktPublishing/Kubernetes-and-Docker-The-Complete-Guide) 

# Section 1. Docker and Container Fundamentals
## Chapter 2. Working with Docker Data
* Docker includes the abilityto add persistent data to a container using two methods:
  * **Docker volumes**:
    * **A volume** is nothing more than a directory on the localhost that is mapped to the container using a volume mount.
    * When you create a volume, a new directory is created on the host filesystem.
    * Every Docker volume has a directory in the `/var/lib/docker/volumes` directory. In each volume folder, there is a directory called `_data` that contains the actual data for the container.
  * **Docker bind-mounts**: using `-v` or `--mount`.
  * **tmpfs mounts**:
    * This type of mount is not persistent through container restarts, Docker restarts, or host reboots.
    * It is only used as a location to temporarily store data in high-speed RAM and is truly ephemeral.
    * Example:
      ```bash
      docker run --mount type=tmpfs,target=/opt/html,tmpfs-mode=1770,tmpfs-size=1000000 --name nginx-test -d bitnami/nginx:latest
      ```
