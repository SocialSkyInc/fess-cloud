#!/bin/bash

ZK_SOLR_SERVER_NAMES=("zksolr-server-1" "zksolr-server-2" "zksolr-server-3")
ZK_SOLR_SERVER_HOSTS=("localhost" "localhost" "localhost")
ZK_SOLR_SERVER_SOLR_PORTS=(8180 8280 8380)
ZK_SOLR_SERVER_SOLR_SHUTDOWN_PORTS=(8181 8281 8381)
ZK_SOLR_SERVER_ZK_PORTS=(9180 9280 9380)

SOLR_SERVER_NAMES=("solr-server-1" "solr-server-2")
SOLR_SERVER_PORTS=(8480 8580)
SOLR_SERVER_SHUTDOWN_PORTS=(8481 8581)

FESS_SERVER_NAMES=("fess-server-1")
FESS_SERVER_PORTS=(8080)
FESS_SERVER_SHUTDOWN_PORTS=(8081)

FESS_CONF=fessconf
FESS_COLLECTION_ALIAS=fess-cloud
FESS_COLLECTION=fess-collection

NUM_SHARDS=5
REPLICATION_FACTOR=3
MAX_SHARDS_PER_NODE=3

