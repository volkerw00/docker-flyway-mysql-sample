MYSQL_SERVER_NAME=me310-mysql

docker stop $MYSQL_SERVER_NAME
docker rm $MYSQL_SERVER_NAME

docker run -d --rm --name $MYSQL_SERVER_NAME -e MYSQL_ALLOW_EMPTY_PASSWORD=true -e MYSQL_DATABASE=sugar_patient_data -p 3306:3306 mysql

# wait for mysql to start
sleep 15

MYSQL_CLIENT_NAME=mysql-me310-client

docker stop $MYSQL_CLIENT_NAME
docker rm $MYSQL_CLIENT_NAME
docker run -it --name $MYSQL_CLIENT_NAME --link $MYSQL_SERVER_NAME:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot'

docker stop $MYSQL_SERVER_NAME
docker stop $MYSQL_CLIENT_NAME