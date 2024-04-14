#!/bin/bash

source .env

domain=$DOMAIN
localCertDir="./certificates"

if [ -d "$localCertDir" ]; then
    echo "certificate directory exists, deleting..."
    rm -rf $localCertDir
    mkdir $localCertDir
    #Create the root key
    openssl ecparam -out $localCertDir/$domain.key -name prime256v1 -genkey
    #Create the root certificate and sign it with the root key
    openssl req -new -nodes -key $localCertDir/$domain.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=$domain" -out $localCertDir/$domain.csr
    #Create the root certificate
    openssl x509 -req -in $localCertDir/$domain.csr -signkey $localCertDir/$domain.key -out $localCertDir/$domain.crt
    #Verify the cert
    openssl x509 -in $localCertDir/$domain.crt -text -noout
else 
    echo "certificate directory does not exist, creating..."
    mkdir $localCertDir
    #Create the root key
    openssl ecparam -out $localCertDir/$domain.key -name prime256v1 -genkey
    #Create the root certificate and sign it with the root key
    openssl req -new -nodes -key $localCertDir/$domain.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=$domain" -out $localCertDir/$domain.csr
    #Create the root certificate
    openssl x509 -req -in $localCertDir/$domain.csr -signkey $localCertDir/$domain.key -out $localCertDir/$domain.crt
    #Verify the cert
    openssl x509 -in $localCertDir/$domain.crt -text -noout
fi