#!/bin/bash
FLYWAY_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MAIN_DIR=$(realpath $FLYWAY_SCRIPT_DIR/../../main)

CONTAINER_NAME=me310-flyway
MYSQL_CONTAINER_NAME=${MYSQL_CONTAINER_NAME:-"me310-mysql"}
    
if MYSQL_SERVER_AVAILABLE="$(docker inspect $MYSQL_CONTAINER_NAME)"; [[ $MYSQL_SERVER_AVAILABLE != "[]" ]]; then
    echo "Linking available mysql container $MYSQL_CONTAINER_NAME"
    NETWORKING="--link $MYSQL_CONTAINER_NAME"
else
    NETWORKING="--net=host"
fi

FLYWAY_CONF_DIR=${FLYWAY_CONF_DIR:-"$MAIN_DIR/resources/conf"}
[[ $(uname) = *"CYGWIN"* ]] && FLYWAY_CONF_DIR=${FLYWAY_CONF_DIR//\/cygdrive\/c/C:}

FLYWAY_SQL_DIR=${FLYWAY_SQL_DIR:-"$MAIN_DIR/resources/sql"}
[[ $(uname) = *"CYGWIN"* ]] && FLYWAY_SQL_DIR=${FLYWAY_SQL_DIR//\/cygdrive\/c/C:}

echo "Running flyway..."
echo "docker run --name $CONTAINER_NAME $NETWORKING -v $FLYWAY_CONF_DIR:/flyway/conf -v $FLYWAY_SQL_DIR:/flyway/sql boxfuse/flyway $@"
docker run --name $CONTAINER_NAME $NETWORKING -v $FLYWAY_CONF_DIR:/flyway/conf -v $FLYWAY_SQL_DIR:/flyway/sql boxfuse/flyway $@

docker stop $CONTAINER_NAME &>/dev/null
docker rm $CONTAINER_NAME &>/dev/null
