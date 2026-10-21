url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
%include fedora-live-xfce.ks
%packages
@xfce-desktop
neovim
git
%end
