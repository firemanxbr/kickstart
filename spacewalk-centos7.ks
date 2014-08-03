# Spacewalk on CentOS 7
# Autor: Marcelo Barbosa
# email: <firemanxbr@fedoraproject.org>
# version=RHEL7

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
network  --hostname=firemanxbr-challenge.chaordic.com.br

# Root password 
# python -c "import crypt, getpass, pwd; \
# print crypt.crypt('spacewalk', '\$6\$saltsalt\$')"
rootpw --iscrypted $6$saltsalt$RhQGGsDK.yRRMNaZ.OeSkuK0KY0k.ipSlA/kUJQ0xBRfE3nzJsbIYgOBGyyVmVQr.YIeoaLydAcIZvejmS83r/

# New system services for ntp servers
services --enabled="chronyd"

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
%end

# Pos installed with log
%post --log=/root/chaordic-ks-post.log

# EPEL - Extra Packages for Enterprise Linux 7
yum localinstall -y http://download.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm

# for updating 
yum upgrade -y

# install utils
yum install -y vim wget

%end

# Reboot after installation
reboot
