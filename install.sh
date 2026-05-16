#!/usr/bin/env sh
set -e 
nix-shell -p git curl --run "./install $1 $2"
