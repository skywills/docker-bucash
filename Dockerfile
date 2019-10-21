FROM alpine
LABEL MAINTAINER="James O'Beirne <james@chaincode.com>"

ARG VERSION=1.7.0.0
ARG GLIBC_VERSION=2.28-r0

ENV COINNAME bitcoin
ENV FILENAME BUcash-${VERSION}-linux64.tar.gz
ENV DOWNLOAD_URL https://www.bitcoinunlimited.info/downloads/${FILENAME}


# Some of this was unabashadly yanked from
# https://github.com/szyhf/DIDockerfiles/blob/master/bitcoin/alpine/Dockerfile

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /${FILENAME} \
  && mkdir /root/.${COINNAME} \
  && mv /BUcash-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /BUcash-${VERSION}/ \
  && rm -rf /${FILENAME} \
  && apk del tar wget ca-certificates

EXPOSE 8332 8333 18332 18333 28332 28333

ADD VERSION .
ADD ./bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
