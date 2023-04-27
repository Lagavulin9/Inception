NAME = inception

SRC_DIR = ./srcs

DOCKER_COMPOSE_FILE = $(SRC_DIR)/docker-compose.yaml

DOCKER_COMPOSE = sudo docker-compose -f $(DOCKER_COMPOSE_FILE)

$(NAME) : all

all : up

clean : stop
	docker rm $$(docker ps -qa); \
	docker rmi -f $$(docker images -qa); \
	docker volume rm $$(docker volume ls -q) || \
	docker network rm $$(docker network ls -q) ||\
	echo "clean up"

re : clean
	docker pull alpine:3.16.5
	$(DOCKER_COMPOSE) build --no-cache
	make up

up :
	docker pull alpine:3.16.5
	$(DOCKER_COMPOSE) up -d --build

down :
	$(DOCKER_COMPOSE) down

start :
	$(DOCKER_COMPOSE) start

restart :
	$(DOCKER_COMPOSE) restart

stop :
	$(DOCKER_COMPOSE) stop

install:
	echo "INSTALL DOCKER"
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	echo "INSTALL DOCKER-COMPOSE"
	sudo curl -SL "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(shell uname -s)-$(shell uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo docker-compose --version

.PHONY: all clean re up down start restart stop insatll
