#!/usr/bin/env sh
set -eu

print_separator() {
   echo ""
   echo ""
   echo ""
}

firefox >/dev/null 2>&1 </dev/null &
printf "Press enter when ssh is downloaded to proceed"
read </dev/tty
echo "continuing"


cp ~/Downloads/github "$tmp_path/github"
chmod 600 "$tmp_path/github"

GIT_SSH_COMMAND="ssh -i $tmp_path/github \
   -o IdentitiesOnly=yes \
   -o StrictHostKeyChecking=accept-new \
   -o BatchMode=yes \
   " \
   git clone \
   git@github.com:TaiseiYokoshima/.dotfiles \
   ~/.dotfiles

mkdir -p ~/.ssh
cp "$tmp_path/config" ~/.ssh/config
mv "$tmp_path/github" ~/.ssh/github

cd ~/.dotfiles
git pull origin main --recurse

print_separator
echo ".dotfiles cloned"
./link_all.bash

print_separator
echo "linked all config"

mkdir -p ~/.config/ssh/keys/
mv ~/.ssh/github ~/.config/ssh/keys/github

cd ~/.ssh
rm *
echo "Include ~/.config/ssh/config" > ~/.ssh/config
python "$tmp_path/test_ssh.py"

cd ~/.dotfiles
./update.sh
print_separator
echo "update complete"

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
nix flake lock
sudo nixos-rebuild switch --flake .#$os
sudo nixos-rebuild boot --flake .#$os

cd ~/.config/home-manager
# nix --extra-experimental-features "nix-command flakes" flake update
nix flake lock
home-manager switch --flake .#$home
