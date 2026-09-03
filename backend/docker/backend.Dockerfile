FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /build

COPY pom.xml ./
COPY ruoyi-admin/pom.xml ruoyi-admin/pom.xml
COPY ruoyi-common/pom.xml ruoyi-common/pom.xml
COPY ruoyi-framework/pom.xml ruoyi-framework/pom.xml
COPY ruoyi-system/pom.xml ruoyi-system/pom.xml

RUN mvn -B -ntp -pl ruoyi-admin -am dependency:go-offline -DskipTests

COPY ruoyi-admin/src ruoyi-admin/src
COPY ruoyi-common/src ruoyi-common/src
COPY ruoyi-framework/src ruoyi-framework/src
COPY ruoyi-system/src ruoyi-system/src

RUN mvn -B -ntp -pl ruoyi-admin -am clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system ruoyi \
    && useradd --system --gid ruoyi --home-dir /app --shell /usr/sbin/nologin ruoyi \
    && mkdir -p /app/data/uploadPath \
    && chown -R ruoyi:ruoyi /app

COPY --from=builder --chown=ruoyi:ruoyi /build/ruoyi-admin/target/ruoyi-admin.jar /app/app.jar

USER ruoyi

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

