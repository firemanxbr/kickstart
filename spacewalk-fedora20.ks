# Spacewalk on Fedora 20
# Autor: Marcelo Barbosa
# email: <firemanxbr@fedoraproject.org>

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
network  --hostname=spacewalk.mydomain.local

# Root password 
# python -c "import crypt, getpass, pwd; \
# print crypt.crypt('spacewalk', '\$6\$saltsalt\$')"
rootpw --iscrypted $6$saltsalt$RhQGGsDK.yRRMNaZ.OeSkuK0KY0k.ipSlA/kUJQ0xBRfE3nzJsbIYgOBGyyVmVQr.YIeoaLydAcIZvejmS83r/

# Firewall configuration
firewall --enabled --service=ssh
firewall --enabled --service=http
firewall --enabled --service=https
firewall --enabled --port=5222:tcp
firewall --enabled --port=5269:tcp
firewall --enabled --port=69:udp

# New system services for ntp servers
services --enabled="chronyd"

# Enable ssh service
services --enabled="sshd"

# System timezone with brazilian ntp servers
timezone America/Sao_Paulo --isUtc --ntpservers=a.ntp.br,b.ntp.br,c.ntp.br

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda

# Simple config using XFS and auto partition
autopart --type=lvm

# Partition clearing information
clearpart --none --initlabel 

# Ajust firewall for ssh, http, https service
firewall --service=ssh

# Packages installed
%packages
@core
chrony
vim
wget
%end

# Pos installed with log
%post --log=/root/spacewalk2.2-fedora20-ks-post.log

# Spacewalk repository
yum localinstall -y http://yum.spacewalkproject.org/2.2/Fedora/20/x86_64/spacewalk-repo-2.2-1.fc20.noarch.rpm

# Install jpackage-generic.repo 
cd /etc/yum.repos.d/
wget https://firemanxbr.fedorapeople.org/kickstart/jpackage-generic.repo
 
# Updating system
yum upgrade -y

# PostgreSQL server, set up by Spacewalk (embedded)
yum install spacewalk-setup-postgresql

# Installing Spacewalk
yum install -y spacewalk-postgresql 

# Ver a configuração do Spacewalk usando Answer File: https://fedorahosted.org/spacewalk/wiki/HowToInstall#ConfiguringSpacewalkwithanAnswerFile

%end

# Reboot after installation
reboot
