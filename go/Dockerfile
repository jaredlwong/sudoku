FROM ubuntu:latest

# Need build-essential for `cc` linker
RUN apt-get update && apt-get install -y build-essential curl

# https://golang.org/doc/install
RUN curl --proto "=https" --tlsv1.2 -sSfL https://golang.org/dl/go1.16.linux-amd64.tar.gz | tar -C /usr/local -xz

ENV GOPATH=/go
ENV GOROOT=/usr/local/go
ENV PATH=${PATH}:${GOROOT}/bin:${GOPATH}/bin

WORKDIR /code
