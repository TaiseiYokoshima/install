#!/usr/bin/env sh
set -e 
nix-shell -p git gh python3 python --run "./install"
