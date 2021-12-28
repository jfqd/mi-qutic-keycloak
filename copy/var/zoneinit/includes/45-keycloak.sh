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

svccfg import /opt/local/lib/svc/manifest/keycloak.xml
svccfg enable /opt/local/lib/svc/manifest/keycloak.xml || true
