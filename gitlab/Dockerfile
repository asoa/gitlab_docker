FROM gitlab/gitlab-ce:latest

EXPOSE 443 2222 5050


## TODO: 
    # - move server PKI creation to a build task run within the container
    # - add docker volume with ca public cert

# ARG DOMAIN=domain.local
# ARG FQDN=gitlab.domain.local

# RUN mkdir -p /etc/gitlab/ssl
# ADD ca_certificates/domain* /etc/gitlab/ssl/

# WORKDIR /etc/gitlab/ssl

# RUN echo "subjectAltName=DNS:$FQDN" > extfile.cnf && \
#     openssl ecparam -out $FQDN.key -name prime256v1 -genkey && \
#     openssl req -new -sha256 -nodes -key $FQDN.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=$FQDN" -out $FQDN.csr && \
#     openssl x509 -req -extfile ./extfile.cnf -in $FQDN.csr -CA $DOMAIN.crt -CAkey $DOMAIN.key -CAcreateserial -out $FQDN.crt -days 365 -sha256 && \
#     cat $DOMAIN.crt >> $FQDN.crt && \
#     rm -f $DOMAIN.crt $DOMAIN.key $FQDN.csr extfile.cnf

# WORKDIR /
    