#FROM debian:stable-slim as build
FROM gakaki/spring_base:latest as build

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile

FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
