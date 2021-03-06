FROM ubuntu:latest

# Set locale to utf8
# https://leimao.github.io/blog/Docker-Locale/
# Elixir checks for this
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV DEBIAN_FRONTEND "noninteractive"

RUN apt-get update && apt-get install -y build-essential locales-all time 

RUN apt-get install -y openjdk-8-jdk-headless

WORKDIR /code
