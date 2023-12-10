FROM alpine:latest

ARG DOMAIN=domain.local
ARG WORKING_DIR=$pwd

# create ca cert
RUN mkdir ${WORKING_DIR}/certificates && \
    apk add --no-cache openssl && \
    openssl req -new -x509 \
    -addext basicConstraints=critical,CA:true \
    -days 365 -nodes \
    -out $DOMAIN.crt -keyout $DOMAIN.key \
    -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=$DOMAIN" && \
    mv $DOMAIN.crt $DOMAIN.key ${WORKING_DIR}/certificates
