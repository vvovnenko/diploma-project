# Build
FROM debian:stable-slim as build
RUN apt-get update && apt-get install git zip build-essential -y

WORKDIR /tmp
RUN git clone https://github.com/wg/wrk

WORKDIR /tmp/wrk
RUN make

# Image
FROM debian:stable-slim
RUN apt-get update && apt-get install netbase -y && rm -rf /var/lib/apt/lists/*
COPY --from=build /tmp/wrk/wrk /usr/local/bin/

# Нерутовий користувач і робоча папка
RUN useradd -m -u 10001 tester
USER 10001:10001
WORKDIR /work
CMD ["bash","-lc","echo 'Loadgen pod is ready. Use: kubectl exec -it <pod> -- bash'; sleep infinity"]
