# CentOS 7
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
network  --hostname=centos7.mydomain.local

# Root password 
# python -c "import crypt, getpass, pwd; \
# print crypt.crypt('centos', '\$6\$saltsalt\$')"
rootpw --iscrypted $6$saltsalt$IVNuyyHg8weFejqIesd4ZjhC4wszvKsnO3yQLN4A4EWt1j4J2grfUOL4b.42RB4Ifr8BQr7/GvSnC7kSlHnc6/

# New system services for ntp servers
services --enabled=chronyd,sshd

# System timezone with brazilian ntp servers
timezone America/Sao_Paulo --isUtc --ntpservers=a.ntp.br,b.ntp.br,c.ntp.br

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda

# Simple config using XFS and auto partition
autopart --type=lvm

# Partition clearing information
clearpart --none --initlabel 

# Firewall configuration
firewall --enabled --ssh

# Packages installed
%packages
@core
chrony
vim
wget
net-tools
%end

# Pos installed with log
%post --log=/root/centos7-ks-post.log

# EPEL - Extra Packages for Enterprise Linux 7
yum localinstall -y http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm

# Install Spacewalk client
yum localinstall -y http://yum.spacewalkproject.org/2.2-client/RHEL/7/x86_64/spacewalk-client-repo-2.2-1.el7.noarch.rpm

# for updating 
yum upgrade -y

%end

# Reboot after installation
reboot
