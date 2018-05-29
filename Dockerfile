ARG NODE_VERSION

FROM node:${NODE_VERSION}

ARG GOSU_VERSION=1.7
ARG TINI_VERSION=0.18.0

# grab gosu for easy step-down from root
RUN wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && wget -qO /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true

# use tini for proper PID 1 management
RUN wget -O /usr/bin/tini "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini" \
  && wget -O /usr/bin/tini.asc "https://github.com/krallin/tini/releases/download/v$TINI_VERSION/tini.asc" \
  && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
  && gpg --verify /usr/bin/tini.asc \
  && chmod +x /usr/bin/tini \
  && rm -f /usr/bin/tini.asc

 # Exclude npm cache from the image
 VOLUME /root/.npm

 WORKDIR /app

 COPY entrypoint.sh /entrypoint.sh
 ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

 CMD ["node"]
