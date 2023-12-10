## docker compose scaffold for CA container
the purpose of this container will be to encapsulate all PKI generation and distribution within an isolated container; only the public.crt will shared via docker volume binding

```
 ca:
     image: alpine:latest
     hostname: ca
     container_name: ca
     networks:
       - gitlab
     build: ./ca
     volumes:
       - ca_certificates:/certificates
     command: 
        TODO: generate CA certificate in docker build or using docker-entrypoint.sh
        TODO: share CA certificate with other containers using shared volume
```
