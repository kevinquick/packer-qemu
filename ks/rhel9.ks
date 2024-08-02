# Localization settings
lang en_US
keyboard --xlayouts='us'
timezone Europe/Amsterdam --utc
# Authentication settings
rootpw $2b$10$6Lki1/RPP3eDaeQGFLgO7.VixVV9BEu6X6rRluDG2UuPBgCi1AVQe --iscrypted

# Installation Mode and Media settings
reboot
text
cdrom
bootloader --append="rhgb quiet crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"

zerombr
clearpart --all --initlabel
ignoredisk --only-use=vda

# Partitioning the first disk as specified
part /boot --fstype="xfs" --ondisk=vda --size=1024
part /boot/efi --fstype="vfat" --ondisk=vda --size=200
part pv.427 --fstype="lvmpv" --ondisk=vda --size=1024 --grow
# Volume Group and Logical Volumes
volgroup rhel --pesize=4096 pv.427
logvol / --fstype="xfs" --size=15360 --name=root --vgname=rhel
logvol /home --fstype="xfs" --size=1024 --name=home --vgname=rhel
logvol /opt --fstype="xfs" --size=1024 --name=opt --vgname=rhel
logvol /tmp --fstype="xfs" --size=2048 --name=tmp --vgname=rhel
logvol /var --fstype="xfs" --size=10240 --name=var --vgname=rhel
logvol /var/log --fstype="xfs" --size=4096 --name=var_log --vgname=rhel
logvol /var/log/audit --fstype="xfs" --size=2048 --name=var_log_audit --vgname=rhel
logvol /var/tmp --fstype="xfs" --size=2048 --name=var_tmp --vgname=rhel
logvol swap --fstype="swap" --size=4096 --name=swap --vgname=rhel
# Set network to DHCP
network --bootproto=dhcp
skipx
firstboot --disable
selinux --enforcing
firewall --enabled --ssh

%packages
@^minimal-environment
kexec-tools
%end

%post
## Install SSH key
### Create directory
mkdir /root/.ssh/

### Create File
cat <<EOF >/root/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhW4YmyB9KKvv6tTDcmGAc+PFeQ0t4PpKFB9CFwCBdt kevin@framework
EOF

### set permissions
chmod 0700 /root/.ssh/
chmod 0600 /root/.ssh/authorized_keys

### fix selinux context
restorecon -R /root/.ssh/

### Enable root login via SSH
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

### Restart SSHD to apply changes
systemctl restart sshd
%end