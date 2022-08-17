#!/usr/bin/bash

if mdata-get mysql_host 1>/dev/null 2>&1; then
  MYSQL_HOST=`mdata-get mysql_host`
  sed -i \
    "s:mysql.example.com:${MYSQL_HOST}:" \
    /opt/keycloak/keycloak/standalone/configuration/standalone.xml
fi

if mdata-get mysql_user 1>/dev/null 2>&1; then
  MYSQL_USER=`mdata-get mysql_user`
  sed -i \
    "s:mysql-keycloak-user:${MYSQL_USER}:" \
    /opt/keycloak/keycloak/standalone/configuration/standalone.xml
fi

if mdata-get mysql_password 1>/dev/null 2>&1; then
  MYSQL_PWD=`mdata-get mysql_password`
  sed -i \
    "s:mysql-keycloak-password:${MYSQL_PWD}:" \
    /opt/keycloak/keycloak/standalone/configuration/standalone.xml
fi

chown -R keycloak:keycloak /opt/keycloak
svccfg import /opt/local/lib/svc/manifest/keycloak.xml
svccfg enable svc:/network/keycloak:keycloak || true

sleep 60
MYSQLJ_VERSION=$(cat /opt/keycloak/MYSQLJ_VERSION | tr -d " \t\n\r")
cd /opt/keycloak/keycloak/
./bin/jboss-cli.sh \
  -c "module add --name=com.mysql --resources=/opt/keycloak/keycloak/modules/system/layers/keycloak/com/mysql/main/mysql-connector-java-${MYSQLJ_VERSION}.jar --dependencies=javax.api,javax.transaction.api" \
  || true

chown -R keycloak:keycloak /opt/keycloak
svccfg restart svc:/network/keycloak:keycloak || true
