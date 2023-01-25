FROM bellsoft/liberica-native-image-kit-container:latest AS build
#FROM ghcr.io/graalvm/jdk:ol8-java17-22.3.0 AS build
#FROM gradle:jdk17-alpine
RUN curl -s "https://get.sdkman.io" | bash
RUN sdk install java 22.3.r17-nik && sdk use java 22.3.r17-nik
RUN sdk install gradle
WORKDIR /app
COPY . .
RUN  gradle nativeCompile

############################
# STEP 2 build a small image
############################
FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java .
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
