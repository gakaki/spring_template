#FROM debian:stable-slim as build
FROM gakaki/spring_base:latest as build

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile
RUN  ls -lh /app/build/native/nativeCompile/

FROM scratch as release
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]

