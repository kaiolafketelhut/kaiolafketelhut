%include /usr/share/spin-kickstarts/fedora-live-base.ks
%include /usr/share/spin-kickstarts/fedora-live-desktop.ks

%packages
neovim
git
xfce-desktop
lightdm
%end

%post
cat > /etc/os-release <<'OS'
NAME="oeneye"
ID=oeneye
ID_LIKE="fedora rhel"
VERSION="1.05 rc"
VERSION_ID="1.05-rc"
PRETTY_NAME="oeneye 1.05 rc (Fedora base) MOSFETQ infinity-eye"
OS
%end
