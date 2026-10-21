# oeneye Fedora 41+ - fixed auth removed
lang en_US.UTF-8
keyboard us
timezone Europe/Berlin --utc
rootpw --iscrypted $6$REPLACE
selinux --enforcing
firewall --enabled --service=ssh
bootloader --location=mbr
clearpart --all --initlabel
autopart
%packages
@xfce-desktop
neovim
git
python3
%end
%post
echo "oeneye installed"
%end
