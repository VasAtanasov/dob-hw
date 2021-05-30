### BUILD image
FROM maven:3.8.1-amazoncorretto-11 as builder

# create app folder for sources
RUN mkdir -p /build

WORKDIR /build

COPY pom.xml /build

#Download all required dependencies into one layer
RUN mvn --no-transfer-progress -B dependency:resolve dependency:resolve-plugins

#Copy source code
COPY src /build/src

# Build application
RUN mvn --no-transfer-progress -Dmaven.test.skip=true package

#### Stage 1: Build the application
FROM amazoncorretto:11-alpine as runtime

RUN apk --no-cache add curl

EXPOSE 8007

#Set app home folder
ENV APP_HOME /app

#Possibility to set JVM options (https://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html)
ENV JAVA_OPTS=""

#Create base app folder
RUN mkdir $APP_HOME

WORKDIR $APP_HOME

#Copy executable jar file from the builder image
COPY --from=builder /build/target/*.jar app.jar

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar" ]