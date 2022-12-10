# 1. Running your first image
# 2. The basic commands
* Run container with **specific hostname** using flag `-h` *[page 20]*.
* Get information on a given container by using `inspect` *[page 21]*.
  * Filter the output using `--format {{.NetworkSettings.IPAddress}}` and `grep` *[page 21]*.
* List of changes made to a container using `diff` *[page 21]*.
* Get the logs of a container using `logs` *[page 22]*.
* Remove all the stopped containers and their volumes that are not referenced by other containers using `rm -v $(docker ps -aq -f status=exited)` *[page 23]*.
* Using `--rm` when running a container will remove the container when it exits *[page 23]*.
* Run **debian** container with `hostname`, `-it` and `--name` flags *[page 24]*.
* Turn the container into an **image** using `commit` *(it does not matter if the container is running or stopped)* *[page 24]*.
  ** Run the commited image using `run` *[page 24]*.
* Delete unused images and keep the using images by `docker image prune -a`.

# 3. Building Images from Dockerfiles
* Build the **cowsay image** using dockerfile *[page 24]*.
  * Build the **cowsay image** using **build** command *[page 25]*.
  * Run the **cowsay-dockerfile** image *[page 25]*.
* The **ENTRYPOINT** instruction lets us specify an executable that is used to handle any arguments passed to docker `run` *[page 26]*.
* Set `*.sh` file to be executable with `chmod +x` *[page 26]*.

# 4. Working with Registries
* Docker login to **Docker Hub** using `docker login` *[page 28]*.
* Push your image to **Docker Hub** using `docker push` *[page 28]*.

# 5. Using the Redis Official Image
* Pull **Redis** images from **Docker Hub** using `docker pull` *[page 30]*.
* Run redis image in the background using `docker run -d` *[page 31]*.
* Link two running containers to each other using `--link` *[page 31]*.
* Run container with volume:
  * Specify the initial data to be loaded into the volume using `--volumes-from` *[page 33]*.
  * Assign the volume from host and container volumes using `-v <host_volume:container_volume>` *[page 33]*.
  * Remove containers and its volumes using `docker rm -v` *[page 33]*.