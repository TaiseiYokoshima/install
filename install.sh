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

chmod 600 ~/Downloads/github

   
GIT_SSH_COMMAND="ssh -i $HOME/Downloads/github \
   -o IdentitiesOnly=yes \
   -o StrictHostKeyChecking=accept-new \
   -o BatchMode=yes \
   " \
   git clone --recurse-submodules \
   git@github.com:TaiseiYokoshima/.dotfiles \
   ~/.dotfiles


exit

print_separator
echo ".dotfiles cloned"

mkdir -p ~/.ssh
echo "Include ~/.config/ssh/config" > ~/.ssh/config

cd ~/.dotfiles
./link_all.bash
mkdir -p ~/.config/ssh/keys/
mv ~/Downloads/github ~/.config/ssh/keys/github

python setup_remotes.py

print_separator
echo "linked all the submodules"



echo "ssh key is now setup"
echo "updating ..."
./update

print_separator
echo "update complete"

echo "Include ~/.config/ssh/config" > ~/.ssh/config




printf "OS entry: "
read os </dev/tty

printf "Home entry: "
read home </dev/tty


echo "Entries Selected"
echo "OS: $os"
echo "Home: $home"


cd ~/.ssh
rm *
echo "Include ~/.config/ssh/config" > ~/.ssh/config

python "$tmp_path/test_ssh.py"

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


rm ~/.ssh/known_hosts
rm ~/.ssh/known_hosts.old
