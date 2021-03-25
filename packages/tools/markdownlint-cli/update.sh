#!/usr/bin/env bash

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

nix-shell -p nodePackages.node2nix --run "node2nix -i $HERE/node-packages.json --nodejs-12"
