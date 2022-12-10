FROM debian

LABEL maintainer="Cuong Duong Manh cuongdm8499@gmail.com"

RUN apt-get update && apt-get install -y cowsay fortune

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
