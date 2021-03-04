FROM ubuntu:latest

# Need build-essential for `cc` linker
RUN apt-get update && apt-get install -y build-essential curl locales locales-all

# Set locale to utf8
# https://leimao.github.io/blog/Docker-Locale/
# Elixir checks for this
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# https://elixir-lang.org/install.html
# https://www.erlang-solutions.com/downloads/
RUN curl --proto '=https' --tlsv1.2 -sSfOL https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb && rm erlang-solutions_2.0_all.deb
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y esl-erlang elixir

WORKDIR /code
