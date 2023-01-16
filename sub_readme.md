# Section 10. Swarm App Lifecycle
## 1. Using Secrets with local docker compose
* In this section, I do not use docker swarm, I focus on how to use the secrets with docker compose. I use the directory `secrets-sample-2` to guide you through the process.
* Move on the `secrets-sample-2` directory and run the following command to create the secrets:
  ```bash
  cd resources/udemy-docker-mastery-main/secrets-sample-2
  docker compose up -d
  docker compose exec psql cat /run/secrets/psql_user
  ```
  ![](./img/sec10/01.png)
    * We can see our secret, why? Because of not as **Docker Swarm**, the secrets are not encrypted in the **Docker Compose**. So we can see out secrets. These secrets are not stored in **Raft Database**.

## 2. Full App Lifecycle: Dev, Build and Deploy with a Single Compose Design
* Sometimes your complexity grows and you are going to need multiple compose files.
* In this scenario, we are going to use `docker compose up` for:
  * Local development environment.
  * Use a **docker compose up config** and file for our CI environment to do integration testing.
  * In production, we are going to use those files for docker stack deploy our app.

### 2.1. Example
* In this guideline, I use the directory `swarm-stack-3`.
  ```bash
  cd resources/udemy-docker-mastery-main/swarm-stack-3
  ll
  ```
  ![](./img/sec10/02.png)
    * Here, we have several docker compose files.
      * `docker-compose.yml`: this is the default compose file. This is called an override.
        * An override is where I have the standard docker compose file, and it sets the defaults that are the same across all my environments.
      * other compose files: these alse called override files. If these files is named with exact prefix name of the default compose file _(such as `docker-compose.test.yml`)_, it will automatically bring this in whenever I do a docker compose up.
        * The cool thing is docker compose will read these files automatically and it will apply this over top, or override, any settings in the `docker-compose.yml` file.

* Now let's run the `docker-compose.yml` file.
  ```bash
  docker compose up -d
  docker image ls
  ```
  ![](./img/sec10/03.png)
  
* Get list of the running containers:
  ```bash
  docker container ls
  ```
  ![](./img/sec10/04.png)
    * We can see, the `drupal` service is currently running.

* Let's inspect the `drupal` service.
  ```bash
  docker container inspect swarm-stack-3-drupal-1
  ```
  ![](./img/sec10/05.png)
    * Focusing on the red square borders, in the file `docker-compose.yml` file, we did not define these volumes, we only defined them in the `docker-compose.override.yml` file, which means when we run `docker compose up`, docker override the `docker-compose.override.yml` file on the top of `docker-compose.yml` file.

* Ya, this is the way that overriding works in docker. Let's down one for further discovery.
  ```bash
  docker compose down
  ```

* Specify `docker-compose.test.yml` file to run the `docker compose up` command.
  ```bash
  docker compose -f docker-compose.yml -f docker-compose.test.yml up -d
  docker container inspect swarm-stack-3-drupal-1
  ```
  ![](./img/sec10/06.png)
    * There is nothing in the `mounts` config because we did not define any volumes in the `docker-compose.test.yml` file.

* Now let's down one.
  ```bash
  docker compose down
  ```

* In production environment, If I run the below command:
  ```bash
  docker compose -f docker-compose.yml -f docker-compose.prod.yml config > output.yml
  ```
    * Docker automatically merges these relevant files with their configuration options into one single `*.yml` file.
    * This is similar to `extends` in **Docker compose**, but keep in your mind that `extends` does not work in **Stacks**.