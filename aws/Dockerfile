FROM ubuntu:22.04

LABEL name="cdm-aws" \
      maintainers="Cuong. Duong Manh" \
      email="cuongdm8499@gmail.com"

WORKDIR /app

RUN apt update && \
    apt install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

CMD ["bash"]