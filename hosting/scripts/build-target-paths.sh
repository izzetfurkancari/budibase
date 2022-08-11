#!/bin/bash

echo ${TARGETBUILD} > /buildtarget.txt
if [[ "${TARGETBUILD}" = "aas" ]]; then
    # Azure AppService uses /home for persisent data & SSH on port 2222
    DATA_DIR=/home
    mkdir -p $DATA_DIR/{search,minio,couchdb}
    mkdir -p $DATA_DIR/couchdb/{dbs,views}
    chown -R couchdb:couchdb $DATA_DIR/couchdb/
    apt update
    apt-get install -y openssh-server
    sed -i "s/#Port 22/Port 2222/" /etc/ssh/sshd_config
    /etc/init.d/ssh restart
fi

sed -i 's#DATA_DIR#$DATA_DIR#' /opt/clouseau/clouseau.ini /opt/couchdb/etc/local.ini
