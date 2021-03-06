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

RUN apt-get install -y openjdk-8-jdk-headless unzip

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Check https://github.com/JetBrains/kotlin for latest version
ENV KOTLIN_VERSION 1.4.31
ENV KOTLIN_HOME /usr/local/kotlin

RUN cd /tmp && \
	curl --proto '=https' --tlsv1.2 -sSfOL https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip && \
	unzip kotlin-compiler-${KOTLIN_VERSION}.zip && \
	mv /tmp/kotlinc ${KOTLIN_HOME} && \
	rm /tmp/kotlin-compiler-${KOTLIN_VERSION}.zip

ENV PATH "${PATH}:${KOTLIN_HOME}/bin"

WORKDIR /code
