#Use a multi-stage build to minimize image size
#Stage 1:Build
FROM maven:3.8.5-openjdk-21 AS build
WORKDIR /app
COPY pom.xml
COPY src ./src
RUN mvn clean package -DskipTests

#Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/springboot-eks-app-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]