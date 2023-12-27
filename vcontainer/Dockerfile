FROM ubuntu:22.04

LABEL name="cdm-vcontainer" \
      maintainers="Cuong. Duong Manh" \
      email="cuongdm8499@gmail.com"
      
RUN apt update && apt install -y traceroute telnet dnsutils curl wget && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz && tar xvf helm-v3.9.3-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin && rm helm-v3.9.3-linux-amd64.tar.gz && \
    rm -rf linux-amd64 && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]

