FROM gakaki/spring_base:latest as builder

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile
#/app/build/native/nativeCompile/

FROM scratch as release
COPY --from=builder /app/build/native/nativeCompile/app .
EXPOSE 8080
ENTRYPOINT ["./app"]

