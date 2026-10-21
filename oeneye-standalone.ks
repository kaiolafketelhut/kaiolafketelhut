# oeneye standalone - fixed
lang en_US.UTF-8
keyboard us
timezone Europe/Berlin --utc
rootpw --iscrypted $6$REPLACE
selinux --enforcing
firewall --enabled
bootloader --location=mbr
clearpart --all --initlabel
autopart
%packages
@xfce-desktop
%end
