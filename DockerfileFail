FROM gakaki/spring_build as builder


FROM alpine
# FROM scratch

# Import from builder.
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

WORKDIR /app
EXPOSE 8080
COPY --from=builder /app/build/native/nativeCompile/java ./
RUN ls /app

USER app:app

ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
