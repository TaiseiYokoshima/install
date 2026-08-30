#!/usr/bin/env sh
set -euo pipefail


print_separator() {
   echo ""
   echo ""
   echo ""
}

gh auth login
print_separator
echo "gh cli initial setup complete"
gh repo clone TaiseiYokoshima/.dotfiles ~/.dotfiles -- --recurse
print_separator
echo "clone the .dotfiles repo and its submodules"

cd ~/.dotfiles
./link_all.bash
python setup_remotes.py

echo "linked all the submodules"

print_separator
echo "Press enter when ssh is downloaded"
read
echo "continuing"

chmod 600 ~/Downloads/github
mv ~/Downloads/github ~/.config/ssh/keys/github

mkdir ~/.ssh
echo "Include ~/.config/ssh/config" > ~/.ssh/config

echo "ssh key is now setup"
echo "updating ..."
./update

print_separator
echo "update complete"

echo "Include ~/.config/ssh/config" > ~/.ssh/config


read -p "OS entry: " os
read -p "Home entry: " home

echo "Entries Selected"
echo "OS: $os"
echo "Home: $home"

cd ~/.config/nixos
cp /etc/nixos/hardware-configuration.nix ./hardware/$os.nix
# nix --extra-experimental-features "nix-command flakes" flake update
sudo nixos-rebuild switch --flake .#$os --install-bootloader
sudo nixos-rebuild boot --flake .#$os

cd ~/.config/home-manager
# nix --extra-experimental-features "nix-command flakes" flake update
home-manager switch --flake .#$home
