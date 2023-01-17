FROM openjdk:8
EXPOSE 8080
ADD target/docker-image-creation.jar docker-image-creation.jar
ENTRYPOINT ["java", "-jar", "/docker-image-creation.jar"]