FROM alpine:3.12

COPY --from=openwhisk/actionloop-base:nightly /bin/proxy /bin/proxy
COPY --from=lolgab/scala-native-docker:latest \
  /usr/lib/libstdc++.so.6 \
  /usr/lib/libgcc_s.so.1 \
  /usr/lib/

CMD [ "/bin/proxy" ]
