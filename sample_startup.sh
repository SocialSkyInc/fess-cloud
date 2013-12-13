#!/bin/bash

cd `dirname $0`
BASE_DIR=`pwd`
BUILD_DIR=$BASE_DIR/target
WAIT_COUNT=$1

if [ x$WAIT_COUNT = "x" ] ; then
    WAIT_COUNT=60
fi

. $BASE_DIR/config.sh

bash $BASE_DIR/build.sh 

chmod +x $BUILD_DIR/*/bin/*.sh

# ZK hosts
for (( I = 0; I < ${#ZK_SOLR_SERVER_NAMES[@]}; ++I )) do
    HOST=${ZK_SOLR_SERVER_HOSTS[$I]}
    ZK_PORT=${ZK_SOLR_SERVER_ZK_PORTS[$I]}
    if [ $I != 0 ] ; then
        ZK_HOSTS="${ZK_HOSTS},"
    fi
    ZK_HOSTS="${ZK_HOSTS}${HOST}:${ZK_PORT}"
done
echo "ZooKeeper Hosts: $ZK_HOSTS"

# Create ZK+Solr Servers
for (( I = 0; I < ${#ZK_SOLR_SERVER_NAMES[@]}; ++I )) do
    NAME=${ZK_SOLR_SERVER_NAMES[$I]}
    echo "Starting $NAME ..."
    $BUILD_DIR/$NAME/bin/startup.sh
done

# Create Solr Servers
for (( I = 0; I < ${#SOLR_SERVER_NAMES[@]}; ++I )) do
    NAME=${SOLR_SERVER_NAMES[$I]}
    echo "Starting $NAME ..."
    $BUILD_DIR/$NAME/bin/startup.sh
done

tail -f $BUILD_DIR/*/logs/catalina.out &
TAIL_PID=$!

sleep $WAIT_COUNT

echo "Creating SolrCloud collection."
java -classpath .:$BUILD_DIR/solr-jars/* org.apache.solr.cloud.ZkCLI -zkhost $ZK_HOSTS -cmd upconfig -confname $FESS_CONF -confdir $BUILD_DIR/solr-config
java -classpath .:$BUILD_DIR/solr-jars/* org.apache.solr.cloud.ZkCLI -zkhost $ZK_HOSTS -cmd linkconfig -collection $FESS_COLLECTION -confname $FESS_CONF

# Create 1 Fess Server
for (( I = 0; I < ${#FESS_SERVER_NAMES[@]}; ++I )) do
    NAME=${FESS_SERVER_NAMES[$I]}
    echo "Starting $NAME ..."
    $BUILD_DIR/$NAME/bin/startup.sh
done

kill $TAIL_PID
tail -f $BUILD_DIR/zksolr-server-1/logs/catalina.out \
    $BUILD_DIR/zksolr-server-2/logs/catalina.out \
    $BUILD_DIR/zksolr-server-3/logs/catalina.out \
    $BUILD_DIR/solr-server-1/logs/catalina.out \
    $BUILD_DIR/fess-server-1/logs/catalina.out 