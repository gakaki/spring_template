FROM gakaki/spring_base:latest as builder

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile

FROM scratch as release
WORKDIR /app
COPY --from=builder /app/build/native/nativeCompile/java ./
EXPOSE 8080
#ENTRYPOINT ["./java"]
CMD ["/app/java"]
