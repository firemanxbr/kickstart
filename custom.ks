# Custom install on CentOS 7
# Autor: Marcelo Barbosa
# email: <firemanxbr@fedoraproject.org>
# ISO Usage: CentOS-7.0-1406-x86_64-DVD.iso

# text mode installation
text

# System authorization information
auth --enableshadow --passalgo=sha512

# Use CDROM installation media
cdrom

# Run the Setup Agent on first boot 
# Ignore other disks, use only 'vda' disk
firstboot --enable
ignoredisk --only-use=vda

# Keyboard layouts
keyboard --vckeymap=br-abnt2 --xlayouts='br'

# System language
lang en_US.UTF-8

# Network information 
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=custom.mydomain.com

# Root password 
# python -c "import crypt, getpass, pwd; \
# print crypt.crypt('custom', '\$6\$saltsalt\$')"
rootpw --iscrypted $6$saltsalt$MTxp/c6mADDEcF6RT9SJ5UIfxkuUZ.KfjgIDUJ62f.jmT.etUfnzjLBk/99DphdZ2aC42p/6Q74VrWm6Qq0iU0

# New system services for ntp servers
services --enabled=chronyd,sshd,httpd,mariadb

# System timezone with brazilian ntp servers
timezone America/Sao_Paulo --isUtc --ntpservers=a.ntp.br,b.ntp.br,c.ntp.br

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda

# Simple config using XFS and auto partition
autopart --type=lvm

# Partition clearing information
clearpart --none --initlabel 

# Firewall configuration
firewall --enabled --ssh --http --https --port=8080:tcp,9990:tcp

# Packages installed
%packages
@core
chrony
vim
wget
net-tools
httpd
mod_cluster
mariadb
%end

# Pos installed with log
%post --log=/root/centos7-ks-post.log

# EPEL - Extra Packages for Enterprise Linux 7
yum localinstall -y http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm

# Install Spacewalk client
yum localinstall -y http://yum.spacewalkproject.org/2.2-client/RHEL/7/x86_64/spacewalk-client-repo-2.2-1.el7.noarch.rpm

# for updating 
yum upgrade -y

# Install MariaDB-Galera
yum install -y mariadb-galera-server mariadb-galera-common

cd /opt
wget https://firemanxbr.fedorapeople.org/kickstart/my.cnf
mv -f /opt/my.cnf /etc/my.cnf

# Install Zabbix Agent
yum install -y zabbix20-agent
systemctl enable zabbix-agent.service

# Install Java for Oracle 
# Verify config java/jar/javac using: "alternatives --config java" and "jar" and "javac"
cd /opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz"
tar zxvf jdk-7u65-linux-x64.tar.gz
cd /opt/jdk1.7.0_65/
alternatives --install /usr/bin/java java /opt/jdk1.7.0_65/bin/java 2
lternatives --set java /opt/jdk1.7.0_65/bin/java
alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_65/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_65/bin/javac 2
alternatives --set jar /opt/jdk1.7.0_65/bin/jar
alternatives --set javac /opt/jdk1.7.0_65/bin/javac 
export JAVA_HOME=/opt/jdk1.7.0_65
export JRE_HOME=/opt/jdk1.7.0_65/jre
export PATH=$PATH:/opt/jdk1.7.0_65/bin:/opt/jdk1.7.0_65/jre/bin

# Install WildFly 8.1.0
cd /opt
wget http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz
tar zxvf wildfly-8.1.0.Final.tar.gz
mv wildfly-8.1.0.Final wildfly
cd /etc/default/
wget https://firemanxbr.fedorapeople.org/kickstart/wildfly.conf
cp /opt/wildfly/bin/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly
chkconfig --level 3 wildfly on
adduser wildfly
gpasswd -a wildfly wildfly
sed 's/127.0.0.1/0.0.0.0/g' /opt/wildfly/standalone/configuration/standalone.xml > /opt/wildfly/standalone/configuration/standalone.xml.new
mv -f /opt/wildfly/standalone/configuration/standalone.xml.new /opt/wildfly/standalone/configuration/standalone.xml
mkdir /var/log/wildfly
chown wildfly.wildfly /var/log/wildfly
chown wildfly.wildfly -R /opt/wildfly

%end

# Reboot after installation
reboot
