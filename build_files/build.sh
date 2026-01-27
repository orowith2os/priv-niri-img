#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

# stolen from https://github.com/Matthias-adR/bizzite/blob/main/build_files/build.sh

dnf5 -y copr enable yalter/niri-git
dnf5 -y copr disable yalter/niri-git
echo "priority=1" | tee -a /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:yalter:niri-git.repo
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:yalter:niri-git install niri
rm -rf /usr/share/doc/niri

dnf5 -y copr enable errornointernet/quickshell
dnf5 -y copr disable errornointernet/quickshell
dnf5 -y --enablerepo copr:copr.fedorainfracloud.org:errornointernet:quickshell install quickshell-git

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y copr disable avengemedia/danklinux
dnf5 -y copr enable avengemedia/dms-git
dnf5 -y copr disable avengemedia/dms-git
dnf5 -y \
    --enablerepo copr:copr.fedorainfracloud.org:avengemedia:dms-git \
    --enablerepo copr:copr.fedorainfracloud.org:avengemedia:danklinux \
    install --setopt=install_weak_deps=False \
    dms \
    dms-cli \
    dms-greeter

curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo | pkexec tee /etc/yum.repos.d/terra.repo
dnf -y terra-release noctalia-shell

mkdir -p /etc/xdg/quickshell
if [ -d /etc/xdg/quickshell/dms ]; then
    rm -rf /etc/xdg/quickshell/dms
fi

git clone https://github.com/AvengeMedia/DankMaterialShell.git /etc/xdg/quickshell/dms


