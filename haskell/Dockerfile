FROM ubuntu:latest

# Need build-essential for `cc` linker
RUN apt-get update && apt-get install -y build-essential curl
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y software-properties-common

# install haskell https://www.haskell.org/downloads/linux/
RUN add-apt-repository -y ppa:hvr/ghc && apt-get update
RUN apt-get install -y cabal-install ghc

WORKDIR /code
