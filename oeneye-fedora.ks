%include fedora-live-base.ks
%include fedora-live-xfce.ks
%packages
@xfce-desktop
neovim
git
%end
%post
echo 'NAME="oeneye"' > /etc/os-release
echo 'ID=oeneye' >> /etc/os-release
echo 'PRETTY_NAME="oeneye 1.05 rc MOSFETQ infinity-eye"' >> /etc/os-release
%end
