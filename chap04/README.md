# 1. The docker architecture
# 2. How images get built
## 2.1. The Build Context
## 2.2. Image layers
* Using `history` command to see the full set of layers that make up an image *[page 42]*.
* Using closest completed images `busybox` when build images from Dockerfile fails *[page 42]*.
## 2.3. Caching
* If you need to invalidate the cache, run docker with `--no-cache` flag *[page 43]*.