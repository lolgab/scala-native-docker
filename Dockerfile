FROM alpine:3.16.2

# Env variables
ARG SCALA_VERSION
ENV SCALA_VERSION ${SCALA_VERSION:-3.2.0}
ARG SCALANATIVE_VERSION
ENV SCALANATIVE_VERSION ${SCALANATIVE_VERSION:-0.4.7}
ARG SBT_VERSION
ENV SBT_VERSION ${SBT_VERSION:-1.7.1}

WORKDIR /workdir
RUN apk --no-cache add clang bash openjdk8 libc-dev build-base
RUN wget -q -O - "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local
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
