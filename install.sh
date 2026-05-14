#!/usr/bin/env sh

set -e 

nix-shell -p git neovim --run '
git clone mgt:TaiseiYokoshima/.dotfiles --recurse
cd .dotfiles
./link_all.bash

cd /home/rom/.config/nixos
sudo nixos-rebuild switch --flake .#$1 --extra-experimental-features "nix-command flakes"

cd /home/rom/.config/home-manager
home-manager switch --flake .#$2 --extra-experimental-features "nix-command flakes"
'
