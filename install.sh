#!/usr/bin/env sh
set -eu

print_separator() {
   echo ""
   echo ""
   echo ""
   sleep 2
   echo "$1"
}

firefox >/dev/null 2>&1 </dev/null &
printf "Press enter when ssh is downloaded to proceed"
read </dev/tty
echo "continuing"

mkdir -p ~/.ssh
cp "$tmp_path/config" ~/.ssh/config
cp ~/Downloads/github ~/.ssh/github
chmod 600 ~/.ssh/github
python "$tmp_path/test_ssh.py"
echo "key found, moved and initial ssh setup"

cd ~
git clone mgh:TaiseiYokoshima/.dotfiles --recurse

print_separator "dotfiles cloned"

cd ~/.dotfiles
./link_all.bash
print_separator "dotfiles linked"

mkdir -p ~/.config/ssh/keys/
mv ~/.ssh/github ~/.config/ssh/keys/github
chmod 600 ~/.config/ssh/keys/github

cd ~/.ssh
rm *
echo "Include ~/.config/ssh/config" > ~/.ssh/config
python "$tmp_path/test_ssh.py"

print_separator "key moved and final ssh setup"

cd ~/.dotfiles
./update.sh

print_separator "update complete"

printf "OS entry: "
read os </dev/tty

printf "Home entry: "
read home </dev/tty


echo "Entries Selected"
echo "OS: $os"
echo "Home: $home"

cd ~/.config/nixos
cp /etc/nixos/hardware-configuration.nix ./hardware/$os.nix
# nix --extra-experimental-features "nix-command flakes" flake update
export NIX_CONFIG='experimental-features = nix-command flakes'
nix flake update
sudo nixos-rebuild switch --flake .#$os
sudo nixos-rebuild boot --flake .#$os

print_separator "nixos built"

cd ~/.config/home-manager
# nix --extra-experimental-features "nix-command flakes" flake update
nix flake update
home-manager switch --flake .#$home
print_separator "home-manager built"
echo "all complete"
