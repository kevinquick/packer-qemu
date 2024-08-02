name                      = "rhel9-packer"
qemu_iso_url              = "https://access.cdn.redhat.com/content/origin/files/sha256/39/398561d7b66f1a4bf23664f4aa8f2cfbb3641aa2f01a320068e86bd1fc0e9076/rhel-9.4-x86_64-dvd.iso?user=5bd582fbea02964757bf637d5e40a650&_auth_=1722529506_8d45ad32213a8b48fd9e2dfc64eb7908"
qemu_iso_checksum         = "sha256:398561d7b66f1a4bf23664f4aa8f2cfbb3641aa2f01a320068e86bd1fc0e9076"
qemu_disk_size            = "50G"
qemu_memory               = "2048"
qemu_cores                = "2"

post_prov_commands = [
    "dnf -y update",
    "dnf -y install qemu-guest-agent python3 python3-pip",
    "subscription-manager unregister",
    "dnf clean all",
    "shred -u /etc/ssh/*_key /etc/ssh/*_key.pub",
    "rm -f /var/run/utmp",
    ">/var/log/lastlog",
    ">/var/log/wtmp",
    ">/var/log/btmp",
    "rm -rf /tmp/* /var/tmp/*",
    "unset HISTFILE; rm -rf /home/*/.*history /root/.*history",
    "rm -f /root/*ks",
    "rm -rf /root/.ssh/*",
    "passwd -d root",
    "passwd -l root"
]