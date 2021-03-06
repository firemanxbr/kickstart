# Spacewalk on Fedora 20
# Autor: Marcelo Barbosa
# email: <firemanxbr@fedoraproject.org>
# ISO Usage: Fedora-20-x86_64-DVD.iso

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

# Firewall configuration for Spacewalk
firewall --enabled --ssh --http --https --port=5222:tcp,5269:tcp,69:udp

# Enable services
services --enabled=chronyd,sshd

# System timezone with brazilian ntp servers
timezone America/Sao_Paulo --isUtc --ntpservers=a.ntp.br,b.ntp.br,c.ntp.br

# System bootloader configuration
bootloader --location=mbr --boot-drive=vda

# Simple config using XFS and auto partition
autopart --type=lvm

# Partition clearing information
clearpart --none --initlabel 

# Packages installed
%packages
@core
net-tools
chrony
vim
wget
%end

# Pos installed with log
%post --log=/root/spacewalk2.2-fedora20-ks-post.log

# Spacewalk repository for Fedora 20
yum localinstall -y http://yum.spacewalkproject.org/2.2/Fedora/20/x86_64/spacewalk-repo-2.2-1.fc20.noarch.rpm

# Install jpackage-generic.repo 
cd /etc/yum.repos.d/
wget https://firemanxbr.fedorapeople.org/kickstart/jpackage-generic.repo
 
# Updating system
yum upgrade -y

# PostgreSQL server, set up by Spacewalk (embedded)
yum install -y spacewalk-setup-postgresql

# Installing Spacewalk
yum install -y spacewalk-postgresql 

# Configure Spacewalk 
cd /root
wget https://firemanxbr.fedorapeople.org/kickstart/spacewalk-postresql
spacewalk-setup --disconnected --answer-file=spacewalk-postgresql
%end

# Reboot after installation
reboot
