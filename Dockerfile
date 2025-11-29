FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080
WORKDIR /usr/app

COPY ./target/java-maven-app-*.jar /usr/app/
ENTRYPOINT ["java", "-jar", "java-maven-app-*.jar"]



