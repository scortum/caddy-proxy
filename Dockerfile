FROM ubuntu:latest
MAINTAINER Alex

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update  \
 && apt-get -y upgrade  \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
    vim \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

# Install Forego
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

ENV DOCKER_GEN_VERSION 0.7.3

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz


VOLUME ["/certs"]

COPY container-content/entry.sh /
COPY container-content/Procfile /
COPY container-content/Caddyfile.template /

ENTRYPOINT ["/entry.sh"]
CMD ["forego", "start", "-r"]
