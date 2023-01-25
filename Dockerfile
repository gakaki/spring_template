FROM gakaki/spring_base:latest

WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile

#RUN  ls -lh /app/build/native/nativeCompile/
#
#FROM scratch as release
#WORKDIR /app
#COPY --from=build /app/build/native/nativeCompile/java /app/java
EXPOSE 8080
ENTRYPOINT ["/app/build/native/nativeCompile/java"]

