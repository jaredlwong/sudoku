FROM ubuntu:latest

# install basics
RUN apt-get update && apt-get install -y build-essential locales time curl

# do this so that apt commands don't ask for interactivity
ENV DEBIAN_FRONTEND "noninteractive"

# https://leimao.github.io/blog/Docker-Locale/
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

################################################################################

RUN apt-get install -y openjdk-8-jdk-headless

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /code
