.PHONY: make_ca_certs create_dirs clean_dir create_ca_certs create_server_certs up down main

include .env
export

create_dirs:
	@echo "** creating directory structure **"
	./scripts/00-make-dirs.sh

clean_dir:
	@echo '** cleaning web dir **'
	rm -rf ./gitlab/volumes/config/*
	rm -rf ./gitlab/volumes/data/*
	rm -rf ./gitlab/volumes/logs/*
	@echo '** cleaning runner dir **'
	rm -rf ./runner/volumes/config/certs/*
	if [[ -f ./runner/volumes/config/config.toml ]]; then rm ./runner/volumes/config/config.toml; fi
	@echo '** cleaning certificates **'
	rm -rf ./certificates/*
	rm -rf ./gitlab/volumes/ca_certs/*

create_ca_certs:
	@echo '** creating ca cert **'
	./scripts/10-make-ca-certs.sh

create_server_certs:
	@echo '** creating server cert **'
	./scripts/20-make-server-certs.sh

rebuild_images:
	@echo '** rebuilding images **'
	docker-compose --env-file ./.env build base_runner

up:
	@echo '** starting containers **'
	docker-compose --env-file ./.env up -d

down:
	@echo '** stopping containers **'
	docker-compose down -v
	docker ps -aq | xargs docker rm -v

main: rebuild_images clean_dir create_ca_certs create_server_certs up

	
