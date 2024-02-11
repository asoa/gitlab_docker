#!/usr/bin/env bash

source .env

sed -i '' 's/#{EXTERNAL_URL}#/'https:\\/\\/"$EXTERNAL_URL"'/g' docker-compose.yml
sed -i '' 's/#{ROOT_PASSWORD}#/'"$ROOT_PASSWORD"'/g' docker-compose.yml