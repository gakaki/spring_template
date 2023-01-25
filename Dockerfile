#FROM debian:stable-slim as build
FROM gakaki/spring_base:latest as build

ARG JAVA_VERSION="22.3.r17-nik"
ARG USER_NAME="jenkins"

ENV JAVA_HOME=/home/${USER_NAME}/.sdkman/candidates/java/current
WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile

FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
