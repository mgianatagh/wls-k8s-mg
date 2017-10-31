#!/bin/bash
#
# Copyright (c) 2014-2015 Oracle and/or its affiliates. All rights reserved.
#
# If AdminServer.log does not exists, container is starting for 1st time
# So it should start NM and also associate with AdminServer
# Otherwise, only start NM (container restarted)
########### SIGTERM handler ############
function _term() {
   echo "Stopping container."
   echo "SIGTERM received, shutting down the server!"
   ${DOMAIN_HOME}/bin/stopWebLogic.sh
}

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down the server!"
   kill -9 $childPID
}

# Set SIGTERM handler
trap _term SIGTERM

# Set SIGKILL handler
trap _kill SIGKILL

ADD_DOMAIN=1
if [ ! -f ${DOMAIN_HOME}/servers/AdminServer/logs/AdminServer.log ]; then
    ADD_DOMAIN=0
fi

# Create Domain only if 1st execution
if [ $ADD_DOMAIN -eq 0 ]; then
# Auto generate Oracle WebLogic Server admin password
#ADMIN_PASSWORD=$(date| md5sum | fold -w 8 | head -n 1)
ADMIN_PASSWORD=Welcome1


echo ""
echo "    Oracle WebLogic Server Auto Generated Empty Domain:"
echo ""
echo "      ----> 'weblogic' admin password: $ADMIN_PASSWORD"
echo ""

sed -i -e "s|ADMIN_PASSWORD|$ADMIN_PASSWORD|g" /u01/oracle/create-wls-domain.py

# Create an empty domain
wlst.sh -skipWLSModuleScanning /u01/oracle/create-wls-domain.py
mkdir -p ${DOMAIN_HOME}/servers/AdminServer/security/
echo "username=weblogic" > /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security/boot.properties
echo "password=$ADMIN_PASSWORD" >> /u01/oracle/user_projects/domains/$DOMAIN_NAME/servers/AdminServer/security/boot.properties
${DOMAIN_HOME}/bin/setDomainEnv.sh
fi

