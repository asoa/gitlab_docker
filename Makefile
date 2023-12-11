.PHONY: make_ca_certs create_dirs clean_dir create_ca_certs create_server_certs compose_up main

include .env
export

create_dirs:
	@creating directory structure main
	./scripts/00_create_dirs.sh

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

compose_up:
	@echo '** starting containers **'
	# ./scripts/sed_helper.sh
	cp docker-compose.yml docker-compose.yml.bak
	sed -i 's/#{EXTERNAL_URL}#/'https:\\/\\/"$$EXTERNAL_URL"'/g' docker-compose.yml
	sed -i 's/#{ROOT_PASSWORD}#/'"$$ROOT_PASSWORD"'/g' docker-compose.yml
	docker-compose --env-file ./.env up -d
	mv docker-compose.yml.bak docker-compose.yml

compose_down:
	@echo '** stopping containers **'
	docker-compose down -v

main: rebuild_images clean_dir create_ca_certs create_server_certs compose_up

	
