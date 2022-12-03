# 1. Quickly to run Docker
* Go to this page to run Docker.
  * [https://labs.play-with-docker.com](https://labs.play-with-docker.com/)
# 2. Some popular commands
|Command|Description|
|-|-|
|`docker version`|Get the information of installed docker on your machine|

# 3. Install docker on your Linux system quickly, run this command
```bash
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
```
* Use this command to grant permission when run command `docker ps` failure
```bash
sudo chmod 666 /var/run/docker.sock
```

# 4. Login to docker
* Firstly need to login in the website [https://hub.docker.com](https://hub.docker.com/)
* Then run this command to login
```bash
docker login
```

