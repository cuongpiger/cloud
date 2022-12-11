# 1. The docker architecture
# 2. How images get built
## 2.1. The Build Context
* Docker ignore files `.dockerignore` *[page 41]*.
## 2.2. Image layers
* Using `history` command to see the full set of layers that make up an image *[page 42]*.
* Using closest completed images `busybox` when build images from Dockerfile fails *[page 42]*.
## 2.3. Caching
* If you need to invalidate the cache, run docker with `--no-cache` flag *[page 43]*.
## 2.4. Base Images
## 2.5. Dockerfile Instructions
* Introduce the popular Dockerfile instructions *[page 47]*.

# 3. Connecting containers to the world
* Using `-P` flag to publish all exposed ports to random ports *[page 49]*.
# 4. Linking containers
* Docker new networking model *[page 50]*.
* `--link` to connect containers *[page 50]*.
# 5. Managing data with Volumes and Data Containers
* Find out where the data is stored in a container by volume *[page 51]*.
  * Three ways to initialize a volume *[page 51]*.
  * Find the dictory of a volume using `-f {{.Mounts}}`*[page 51]*.
* Setting volume permissions in Dockerfiles *[page 52]*.
* Be aware of docker will remove the volume when the (temporary) container is removed *[page 52]*.
## 5.1. Sharing data
* Using `--volumes-from` to share data between containers *[page 53]*.
## 5.2. Data containers
# 6. Common Docker commands
