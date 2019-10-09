FROM alpine:3.10

COPY --from=lolgab/scala-native-build:2.11.12_0.3.9 \
  /usr/lib/libunwind.so.8 \
  /usr/lib/libunwind-x86_64.so.8 \
  /usr/lib/libstdc++.so.6 \
  /usr/lib/libgcc_s.so.1 \
  /usr/local/lib/libre2.so.0 \
  /usr/lib/
