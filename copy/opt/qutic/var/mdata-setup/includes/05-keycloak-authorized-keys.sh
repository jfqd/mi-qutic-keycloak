#!/bin/bash
# Configure ruby ssh authorized_keys file if available via mdata

if mdata-get ruby_authorized_keys 1>/dev/null 2>&1; then
  home='/opt/keycloak'
  mkdir -p ${home}/.ssh
  echo "# This file is managed by mdata-get ruby_authorized_keys" \
    > ${home}/.ssh/authorized_keys
  mdata-get admin_authorized_keys >> ${home}/.ssh/authorized_keys
  chmod 700 ${home}/.ssh
  chmod 640 ${home}/.ssh/authorized_keys
  chown keycloak:keycloak ${home}/.ssh/authorized_keys
fi
