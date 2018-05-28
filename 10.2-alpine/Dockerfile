ARG NODE_VERSION=10.2.1-alpine
ARG DUMB_INIT_VERSION=1.2.0

# Reference dumb-init so we can copy it over
FROM dumb-init:${DUMB_INIT_VERSION} as DUMB_INIT

FROM node:${NODE_VERSION}

# Add dumb-init for proper PID 1 management
COPY --from=DUMB_INIT dumb-init /usr/bin/dumb-init

# Add su-exec for easy step-down from root
RUN apk add --no-cache su-exec

# Exclude npm cache from the image
VOLUME /root/.npm

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["node"]
