# This python script is used to create a WebLogic domain

domain_name  = os.environ.get("DOMAIN_NAME")
admin_port   = int(os.environ.get("ADMIN_PORT"))
managed_port1 = int("7003")
managed_port2 = int("7003")
managed_port3 = int("7003")
admin_pass   = "welcome1"
domain_path  = os.environ.get("DOMAIN_HOME")
server_name1  = "managed-server-0"
server_name2  = "managed-server-1"
server_name3  = "managed-server-2"

print('domain_name     : [%s]' % domain_name);
print('admin_port      : [%s]' % admin_port);
print('managed_port1   : [%s]' % managed_port1);
print('managed_port2   : [%s]' % managed_port2);
print('managed_port3   : [%s]' % managed_port3);
print('domain_path     : [%s]' % domain_path);
print('admin password  : [%s]' % admin_pass);
print('server_name1    : [%s]' % server_name1);
print('server_name2    : [%s]' % server_name2);
print('server_name3    : [%s]' % server_name3);

# Open default domain template
# ======================
readTemplate("/u01/oracle/wlserver/common/templates/wls/wls.jar")

set('Name', domain_name)
setOption('DomainName', domain_name)

# Configure the Administration Server and SSL port.
# =========================================================
cd('/Servers/AdminServer')
set('ListenAddress', '')
set('ListenPort', admin_port)

# Define the user password for weblogic
# =====================================
cd('/Security/%s/User/weblogic' % domain_name)
cmo.setPassword(admin_pass)

# Write the domain and close the domain template
# ==============================================
setOption('OverwriteDomain', 'true')

cd('/NMProperties')
set('ListenAddress','')
set('ListenPort',5556)
set('CrashRecoveryEnabled', 'true')
set('NativeVersionEnabled', 'true')
set('StartScriptEnabled', 'false')
set('SecureListener', 'false')
set('LogLevel', 'FINEST')

# Set the Node Manager user name and password (domain name will change after writeDomain)
cd('/SecurityConfiguration/base_domain')
set('NodeManagerUsername', 'weblogic')
set('NodeManagerPasswordEncrypted', admin_pass)

# Create 3 managed servers
cd('/')
create(server_name1, 'Server')
cd('Servers/' + server_name1)
set('ListenPort', managed_port1)
set('ListenAddress', '')
cd('/')
create(server_name2, 'Server')
cd('Servers/' + server_name2)
set('ListenPort', managed_port2)
set('ListenAddress', '')
cd('/')
create(server_name3, 'Server')
cd('Servers/' + server_name3)
set('ListenPort', managed_port3)
set('ListenAddress', '')

# wls-exporter.war deployment
cd('/')
create('wls-exporter', 'AppDeployment')
cd('/AppDeployments/wls-exporter/')
set('ModuleType', 'war')
set('StagingMode', 'nostage')
set('SourcePath', '/u01/weblogic/apps/wls-exporter.war')
set('Target', 'AdminServer')

# Write Domain
# ============
writeDomain(domain_path)
closeTemplate()

# Exit WLST
# =========
exit()
