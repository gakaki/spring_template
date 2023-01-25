FROM bellsoft/liberica-native-image-kit-container:latest AS build

WORKDIR /app
COPY . .
RUN gradle nativeCompile

############################
# STEP 2 build a small image
############################
FROM scratch
WORKDIR /app
COPY --from=build /app/build/native/nativeCompile/java /app/java
EXPOSE 8080
ENTRYPOINT ["/app/java"]
CMD ["/app/java"]
