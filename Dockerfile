FROM debian:stable-slim as build

ARG JAVA_VERSION="22.3.r17-nik"
ARG USER_UID="1000"
ARG USER_GID="1000"
ARG USER_NAME="jenkins"

RUN groupadd -g $USER_GID $USER_NAME && \
	useradd -m -g $USER_GID -u $USER_UID $USER_NAME

RUN apt update && \
	apt install -y zip unzip curl && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

USER $USER_UID:$USER_GID

RUN curl -s "https://get.sdkman.io" | bash

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION &&  \
    yes | sdk use java $JAVA_VERSION && \
    yes | sdk default java $JAVA_VERSION && \
    yes | sdk install maven && \
    yes | sdk install gradle && \
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"

WORKDIR /app
COPY . .
RUN  gradle nativeCompile


FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
