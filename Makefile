CONTAINER_PATH:=/var/www
DOCKER_COMPOSE:=docker-compose
UP:=up -d --build
DOWN:=stop
CONTAINER_NAME:=container_back
DB_NAME:=container_db
EXEC:=docker exec
BIN:=${EXEC} -w ${CONTAINER_PATH} ${CONTAINER_NAME} php bin/console
CACHE:=cache:clear
$ENTITY:=User


init: start
	${EXEC} -w ${CONTAINER_PATH} ${CONTAINER_NAME} composer install

start:
	${DOCKER_COMPOSE} ${UP}

stop:
	${DOCKER_COMPOSE} ${DOWN}

prune:
	docker volume prune

bash: start
	${EXEC} -ti ${CONTAINER_NAME} bash

db: start
#mysql
	${EXEC} -ti ${DB_NAME} mysql -u root -ppassword NAME
#postgres
	#${EXEC} -ti ${DB_NAME} psql -U user -d NAME -w

cache-clear:
	${BIN} ${CACHE}

database-create:
	${BIN} doctrine:database:create --if-not-exists

migration:
	$(BIN) make:migration

migrate:
	$(BIN) d:m:m --no-interaction

database-drop:
	${BIN} d:d:d --force --if-exists

truncate:
	#${BIN} doctrine:query:sql "TRUNCATE table_name CASCADE"

insert-data: truncate
#mysql
	${EXEC} -i ${DB_NAME} mysql -u user -ppassword NAME < database/dump.sql
#postgres
	#${EXEC} -i ${DB_NAME} psql -U user -d NAME < database/dump.sql

log:
	docker logs -f ${CONTAINER_NAME}
