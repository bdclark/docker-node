FROM alpine:3.7 as DUMB_INIT
ARG DUMB_INIT_VERSION=1.2.0
RUN apk add --no-cache --virtual .install-deps openssl
RUN wget https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64
RUN wget https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/sha256sums
RUN grep dumb-init_${DUMB_INIT_VERSION}_amd64$ sha256sums | sha256sum -c
RUN mv dumb-init_${DUMB_INIT_VERSION}_amd64 dumb-init
RUN chmod +x dumb-init