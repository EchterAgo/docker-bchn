FROM debian:stable-slim
LABEL maintainer="Axel Gembe <derago@gmail.com>"

ENV BITCOIN_VERSION=22.1.0
ENV BITCOIN_FILENAME=bitcoin-cash-node-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz
ENV BITCOIN_URL=https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases/download/v${BITCOIN_VERSION}/${BITCOIN_FILENAME}
ENV BITCOIN_SHA256=aa1002d51833b0de44084bde09951223be4f9c455427aef277f91dacd2f0f657  
ENV BITCOIN_DATA=/data
ENV PATH=/opt/bitcoin-cash-node-${BITCOIN_VERSION}/bin:$PATH

RUN set -ex && \
    apt-get update -y && \
    apt-get install -y curl libjemalloc2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -SLO "$BITCOIN_URL" && \
    echo "$BITCOIN_SHA256 $BITCOIN_FILENAME" | sha256sum -c - && \
    tar -xzf *.tar.gz -C /opt && \
    rm *.tar.gz && \
    apt-get remove -y curl && \
    apt-get autoremove -y

VOLUME ["/data"]
RUN ln -s /data /.bitcoin

EXPOSE 8332 8333 18332 18333 18443 18444 28332 28333 38332 38333

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
