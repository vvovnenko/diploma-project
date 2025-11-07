FROM alpine:3.12 as build
ARG WRK2_COMMIT_HASH=44a94c17d8e6a0bac8559b53da76848e430cb7a7
# Install deps and build from source
RUN apk add --no-cache openssl-dev zlib-dev git make gcc musl-dev alpine-sdk perl linux-headers
RUN git clone https://github.com/giltene/wrk2 && cd wrk2 && git checkout $WRK2_COMMIT_HASH && make

#########
RUN cd /tmp                               && \
    git clone -b 4.2.0 https://github.com/wg/wrk
RUN cd /tmp/wrk                           && \
    make
#########

FROM alpine:3.12
# it seems libgcc_s.so is dynamically linked so we need to install libgcc
RUN apk add --no-cache libgcc curl

COPY --from=build /wrk2/wrk /usr/bin/wrk2

#########
COPY --from=build /tmp/wrk/wrk /usr/local/bin
#########

RUN adduser -D -H -u 10001 wrk_user
USER wrk_user

WORKDIR /work

CMD ["bash","-lc","echo 'Loadgen pod is ready. Use: kubectl exec -it <pod> -- bash'; sleep infinity"]
