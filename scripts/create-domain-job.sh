#!/bin/bash
#
export DOMAIN_HOME=/u01/weblogic/domains/base_domain
export DOMAIN_NAME=base_domain
export ADMIN_PORT=7001
export PRODUCTION_MODE=prod

# Create the domain
wlst.sh -skipWLSModuleScanning /u01/test/scripts/create-domain.py

mkdir -p ${DOMAIN_HOME}/servers/AdminServer/security/
echo "username=weblogic" > $DOMAIN_HOME/servers/AdminServer/security/boot.properties
echo "password=welcome1" >> $DOMAIN_HOME/servers/AdminServer/security/boot.properties

mkdir -p ${DOMAIN_HOME}/servers/ms1/security/
echo "username=weblogic" > $DOMAIN_HOME/servers/ms1/security/boot.properties
echo "password=welcome1" >> $DOMAIN_HOME/servers/ms1/security/boot.properties

mkdir -p ${DOMAIN_HOME}/servers/ms2/security/
echo "username=weblogic" > $DOMAIN_HOME/servers/ms2/security/boot.properties
echo "password=welcome1" >> $DOMAIN_HOME/servers/ms2/security/boot.properties

mkdir -p ${DOMAIN_HOME}/servers/ms3/security/
echo "username=weblogic" > $DOMAIN_HOME/servers/ms3/security/boot.properties
echo "password=welcome1" >> $DOMAIN_HOME/servers/ms3/security/boot.properties