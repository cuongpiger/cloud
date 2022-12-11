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