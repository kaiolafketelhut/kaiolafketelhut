%include fedora-live-xfce.ks

%packages
neovim
git
# add your oeneye tools here, NOT as shell commands
%end

%post
cat > /etc/os-release <<'OS'
NAME="oeneye"
ID=oeneye
ID_LIKE=fedora
VERSION="1.05 rc"
VERSION_ID="1.05-rc"
PRETTY_NAME="oeneye 1.05 rc (Fedora 44 base) - MOSFETQ infinity-eye"
OS
# wallpaper / MOSFETQ theme would go here
%end
