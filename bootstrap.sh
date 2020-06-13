#!/bin/bash

if [[ $(id -u) -ne 0 ]]; 
  then echo "Ubuntu dev bootstrapper, APT-GETs all the things -- run as root...";
  exit 1; 
fi

# https://www.google.com/linuxrepositories/
# https://www.microsoft.com/net/core#linuxubuntu
# https://code.visualstudio.com/docs/setup/linux
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

echo "Update and upgrade all the things..."

apt-get update -y
#apt-get upgrade -y

echo "Some essentials..."
apt-get install -y curl wget git xclip \
  apt-transport-https ca-certificates gnupg-agent build-essential software-properties-common

# Chrome setup
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg --install google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Docker setup - https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

   apt-get update
   apt-get install docker-ce docker-ce-cli containerd.io

# ASP.net setup - https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-3.0.100
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

add-apt-repository universe
apt-get update -y
apt-get install -y dotnet-sdk-3.1

# F# setup
sudo apt install gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

sudo apt-get update
sudo apt-get install fsharp

# VS Code setup - https://code.visualstudio.com/docs/setup/linux
sudo snap install --classic code

# Node setup - https://github.com/nodesource/distributions/blob/master/README.md
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs

# build tools
apt-get install -y gcc g++ make

echo '
export PATH=$PATH:/usr/local/go/bin
' >> ~/.profile

# adds the cuurent user who is sudo'ing to a docker group:
groupadd docker
usermod -aG docker $SUDO_USER
service docker restart

cat << EOF

# now....

code --install-extension dbaeumer.vscode-eslint
code --install-extension Ionide.Ionide-FAKE
code --install-extension Ionide.Ionide-fsharp
code --install-extension Ionide.Ionide-Paket
code --install-extension jchannon.csharpextensions
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode.csharp
code --install-extension wesbos.theme-cobalt2
code --install-extension dsznajder.es7-react-js-snippet

code --list-extensions

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

ssh-keygen -t rsa -b 4096 -C "you@example.com"

eval "\$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

# also check docker... you may need to login again for groups to sort out
# try >> docker run hello-world

# also, consider running:
sudo apt autoremove

EOF
