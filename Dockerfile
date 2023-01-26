FROM gakaki/spring_base:latest as builder

WORKDIR /app
COPY . .
RUN  gradle nativeCompile

FROM scratch as release
WORKDIR /app
COPY --from=builder /app/build/native/nativeCompile/java ./
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
