ARG UBUNTU_VERSION=focal
FROM ubuntu:$UBUNTU_VERSION

# Env variables
ARG SCALA_VERSION
ENV SCALA_VERSION ${SCALA_VERSION:-2.13.8}
ARG SCALANATIVE_VERSION
ENV SCALANATIVE_VERSION ${SCALANATIVE_VERSION:-0.4.4}
ARG SBT_VERSION
ENV SBT_VERSION ${SBT_VERSION:-1.6.2}

WORKDIR /workdir
RUN apt-get update && \
    apt-get install -y curl clang openjdk-8-jdk libuv1-dev libssl-dev libcurl4-openssl-dev && \
    curl --output /usr/share/keyrings/nginx-keyring.gpg \
         https://unit.nginx.org/keys/nginx-keyring.gpg && \
    # Install NGINX Unit
    echo "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ $UBUNTU_VERSION unit" >> /etc/apt/sources.list.d/unit.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/ubuntu/ $UBUNTU_VERSION unit" >> /etc/apt/sources.list.d/unit.list && \
    apt-get update && \
    apt-get install -y unit-dev
# Install Sbt
RUN curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local
ENV PATH=/usr/local/sbt/bin:$PATH
# Prepare sbt (warm cache)
RUN \
  mkdir -p project && \
  mkdir -p src/main/scala && \
  echo "scalaVersion := \"$SCALA_VERSION\"" > build.sbt && \
  echo "enablePlugins(ScalaNativePlugin)" >> build.sbt && \
  echo "sbt.version=$SBT_VERSION" > project/build.properties && \
  echo "addSbtPlugin(\"org.scala-native\" % \"sbt-scala-native\" % \"$SCALANATIVE_VERSION\")" > project/plugins.sbt && \
  echo "object Main { def main(args: Array[String]): Unit = {} }" > src/main/scala/Main.scala && \
  sbt nativeLink && \
  rm -rf project && rm build.sbt && rm -rf src && rm -rf target
