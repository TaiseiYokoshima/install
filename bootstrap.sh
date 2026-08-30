#!/usr/bin/env sh
set -e 

tmp_path=/tmp/install_taisei_nixos

mkdir -p "$tmp_path"

curl -L https://github.com/TaiseiYokoshima/install/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1 -C "$tmp_path"

cd "$tmp_path"
nix-shell -p git gh python3 --run "sh install.sh"
