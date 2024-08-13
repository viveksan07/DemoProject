# Stage 1: Build the application
FROM maven:3.8.5-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml /app/
RUN mvn dependency:go-offline -B

# Copy the source code and build the application
COPY src /app/src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:11-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/Coronavirus-Tracker-0.0.1-SNAPSHOT.jar /app/Coronavirus-Tracker.jar

# Expose the port that the application will run on
EXPOSE 80

# Run the application
ENTRYPOINT ["java", "-jar", "Coronavirus-Tracker.jar"]
