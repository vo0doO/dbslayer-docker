FROM alpine:3.6 AS build

ENV DBSLAYER_VERSION d19e489ef221ebe0b097b8755e6fe32b8b4a61bc

RUN apk add --no-cache build-base apr-dev mariadb-dev apr-util-dev
ADD https://github.com/derekg/dbslayer/archive/$DBSLAYER_VERSION.tar.gz /dbslayer.tar.gz
RUN mkdir /dbslayer
RUN tar --strip 1 -C /dbslayer -xzf /dbslayer.tar.gz

WORKDIR /dbslayer
RUN     ./configure
RUN     make

FROM alpine:3.6
RUN apk add --no-cache apr mariadb-client-libs apr-util
COPY --from=build /dbslayer/server/dbslayer /usr/bin/dbslayer

ENTRYPOINT ["/usr/bin/dbslayer"]