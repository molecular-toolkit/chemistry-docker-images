FROM python:3.6-slim

# This is the environment that "docker-make" will run in on the CI server
# The expected build context is the root of the `chemistry-docker-images` repository
# The docker daemon's socket (usually /var/run/docker.sock) be mounted into the container

RUN apt-get update && apt-get install -y curl

# Install docker CLI only, not the full engine
WORKDIR /tmp
ENV DOCKER_VER=17.09.0-ce
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tgz \
  && tar xzvf docker-${DOCKER_VER}.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-${DOCKER_VER}.tgz

ADD requirements.txt /opt/chemistry-docker-images/requirements.txt
RUN pip install -r /opt/chemistry-docker-images/requirements.txt

ADD . /opt/chemistry-docker-images
WORKDIR /opt/chemistry-docker-images


