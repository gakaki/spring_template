#FROM bellsoft/liberica-native-image-kit-container:latest AS build
##FROM ghcr.io/graalvm/jdk:ol8-java17-22.3.0 AS build
##FROM gradle:latest as build

FROM debian:stable-slim as Build

ARG JAVA_VERSION="22.3.r17-nik"
ARG MAVEN_VERSION="3.6.2"

ARG USER_UID="1000"
ARG USER_GID="1000"
ARG USER_NAME="jenkins"

# Creating default non-user
RUN groupadd -g $USER_GID $USER_NAME && \
	useradd -m -g $USER_GID -u $USER_UID $USER_NAME

# Installing basic packages
RUN apt-get update && \
	apt-get install -y zip unzip curl && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

# Switching to non-root user to install SDKMAN!
USER $USER_UID:$USER_GID

# Downloading SDKMAN!
RUN curl -s "https://get.sdkman.io" | bash

# Installing Java and Maven, removing some unnecessary SDKMAN files
# yes | sdk install java $JAVA_VERSION && \
# yes | sdk install maven $MAVEN_VERSION && \
ENV SDKMAN_DIR=/root/.sdkman

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION &&  \
    yes | sdk use java $JAVA_VERSION && \
    yes | sdk default java $JAVA_VERSION && \
    yes | sdk install maven && \
    yes | sdk install gradle && \
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/* && \
    export JAVA_HOME=$SDKMAN_DIR/candidates/java/current"

ENV JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile


FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
