FLYWAY_TEST_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MAIN_DIR=$(realpath $FLYWAY_TEST_SCRIPT_DIR/../../main)

FLYWAY_SCRIPT_DIR="$MAIN_DIR/scripts"
FLYWAY_SQL_DIR="$MAIN_DIR/resources/sql"

source $FLYWAY_TEST_SCRIPT_DIR/docker_helpers.sh

MYSQL_SERVER_NAME=me310-mysql

docker stop $MYSQL_SERVER_NAME &>/dev/null
docker rm $MYSQL_SERVER_NAME &>/dev/null

echo "Running mysql in container $MYSQL_SERVER_NAME."
docker run -d --name $MYSQL_SERVER_NAME -e MYSQL_ALLOW_EMPTY_PASSWORD=true -e MYSQL_DATABASE=sugar_patient_data -p 3306:3306 --health-cmd='mysqladmin ping --silent' mysql

# wait for mysql server to start
echo "Waiting for container $MYSQL_SERVER_NAME to start."
waitContainer $MYSQL_SERVER_NAME
echo "Container $MYSQL_SERVER_NAME started."

FLYWAY_TEST_CONF_DIR=$(realpath $FLYWAY_TEST_SCRIPT_DIR/../resources/conf)
[[ $(uname) = *"CYGWIN"* ]] && FLYWAY_TEST_CONF_DIR=${FLYWAY_TEST_CONF_DIR//\/cygdrive\/c/C:}
[[ $(uname) = *"CYGWIN"* ]] && FLYWAY_SQL_DIR=${FLYWAY_SQL_DIR//\/cygdrive\/c/C:}

MYSQL_CONTAINER_NAME=$MYSQL_SERVER_NAME FLYWAY_CONF_DIR=$FLYWAY_TEST_CONF_DIR FLYWAY_SQL_DIR=$FLYWAY_SQL_DIR $FLYWAY_SCRIPT_DIR/flyway.sh $@

docker stop $MYSQL_SERVER_NAME &>/dev/null
docker rm $MYSQL_SERVER_NAME &>/dev/null
