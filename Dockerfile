FROM gakaki/spring_base:latest as builder

WORKDIR /app
COPY . .
RUN  gradle nativeCompile

# FROM scratch as release
# WORKDIR /app
# COPY --from=builder /app/build/native/nativeCompile/java ./
# EXPOSE 8080
# USER jenkins:jenkins
# # ENTRYPOINT ["/app/java"]
# CMD ["/app/java"]

FROM alpine
WORKDIR /app
COPY --from=builder /app/build/native/nativeCompile/java ./

ARG USER_NAME="jenkins"
USER $USER_NAME:$USER_NAME

EXPOSE 8080
CMD ["/app/java"]