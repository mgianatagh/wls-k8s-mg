#---------------------------------------------------------------
# This Dockerfile generates a new docker image with the name wls-exporter by doing the following:
#
# 1. Pull the 12.2.1.2 weblogic docker image from the docker store
#
# 2. Copies the wls-exporter application to the image
#
# 3. Copies scripts to create a domain, start a domain and deploy an application to the image
#
# 4. Creates an empty domain
#
# 5. Deploys the wls-exporter application to the domain
#
# 6. Sets the container image to automatically start the domain
#
#---------------------------------------------------------------

# Pull base image, start with an off the shelf image from the docker store
FROM store/oracle/weblogic:12.2.1.2

USER oracle

# Environment variables required for this build (do NOT change)
ENV DEFAULT_AS_NAME="AdminServer" \
    DEFAULT_TARGET_NAME="AdminServer" \
    WLST="$ORACLE_HOME/oracle_common/common/bin/wlst.sh" \
    MW_HOME="$ORACLE_HOME" \
    PATH="$ORACLE_HOME/wlserver/server/bin:$ORACLE_HOME/wlserver/../oracle_common/modules/org.apache.ant_1.9.2/bin:$JAVA_HOME/jre/bin:$JAVA_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$ORACLE_HOME/oracle_common/common/bin:$ORACLE_HOME/wlserver/common/bin:$ORACLE_HOME/wlserver/../oracle_common/modules/org.apache.maven_3.2.5/bin"

# Copy apps
COPY apps/wls-exporter.war /u01/apps/wls-exporter.war

# Copy scripts
# --------------------------------
COPY container-scripts/createEmptyDomain.sh /u01/oracle/createEmptyDomain.sh
COPY container-scripts/startDomain.sh /u01/oracle/startDomain.sh
COPY container-scripts/add-app-to-domain.py /u01/oracle/add-app-to-domain.py

# Create an empty domain
RUN . /u01/oracle/createEmptyDomain.sh

# Use WLST offline to update the domain configuration
RUN . $ORACLE_HOME/wlserver/server/bin/setWLSEnv.sh && \
    java weblogic.WLST /u01/oracle/add-app-to-domain.py $DOMAIN_HOME $DEFAULT_TARGET_NAME $DEFAULT_AS_NAME \
         wls-exporter /u01/apps/wls-exporter.war

# Command to run when the container is started
CMD "/u01/oracle/startDomain.sh"
