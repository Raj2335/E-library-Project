# Multi-stage Dockerfile
# 1) Build the project using Maven + JDK 17
# 2) Run the produced WAR on Tomcat 9 with JDK 17

FROM maven:3.8.8-eclipse-temurin-17 AS build
WORKDIR /workspace

# cache dependencies
COPY pom.xml ./
RUN mvn -B -DskipTests dependency:go-offline

# copy source and build
COPY src ./src
RUN mvn -B -DskipTests package

FROM tomcat:9.0-jdk17
ENV CATALINA_HOME=/usr/local/tomcat

# Copy the built WAR into Tomcat webapps (preserve context name)
COPY --from=build /workspace/target/elibrary.war ${CATALINA_HOME}/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
