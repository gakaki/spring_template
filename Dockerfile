#FROM bellsoft/liberica-native-image-kit-container:latest AS build
FROM ghcr.io/graalvm/jdk:ol8-java17-22.3.0 AS build
WORKDIR /app
COPY . .
RUN  ./gradlew nativeCompile

############################
# STEP 2 build a small image
############################
FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
