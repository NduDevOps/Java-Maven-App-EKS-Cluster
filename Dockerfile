FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

WORKDIR /usr/app
COPY ./target/java-maven-app-1.1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]

