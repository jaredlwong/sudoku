FROM ubuntu:latest

# Need build-essential for `cc` linker
RUN apt-get update && apt-get install -y build-essential curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# WORKDIR /code

# CMD ["/bin/bash"]
# ENTRYPOINT ["/bin/bash", "-l", "-c"]
