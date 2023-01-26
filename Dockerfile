FROM gakaki/spring_build:latest as builder


# FROM scratch as release
# WORKDIR /app
# COPY --from=builder /app/build/native/nativeCompile/java ./
# EXPOSE 8080
# USER jenkins:jenkins
# # ENTRYPOINT ["/app/java"]
# CMD ["/app/java"]

FROM alpine

# Import from builder.
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

WORKDIR /app

EXPOSE 8080

COPY --from=builder /app/build/native/nativeCompile/java ./
RUN ls /app

USER app:app

CMD ["/app/java"]