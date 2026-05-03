#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <mbp-ip-or-hostname>"
  exit 1
fi

TARGET="$1"
EXTRA_FILES="/tmp/server-media-extra-files"

if [ ! -d "$EXTRA_FILES/etc/ssh" ]; then
  echo "Error: $EXTRA_FILES not set up. Run host key generation first:"
  echo "  ssh-keygen -t ed25519 -f /tmp/server-media-hostkey -N ''"
  echo "  mkdir -p $EXTRA_FILES/etc/ssh"
  echo "  cp /tmp/server-media-hostkey $EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"
  echo "  cp /tmp/server-media-hostkey.pub $EXTRA_FILES/etc/ssh/ssh_host_ed25519_key.pub"
  echo "  chmod 600 $EXTRA_FILES/etc/ssh/ssh_host_ed25519_key"
  exit 1
fi

cd "$(dirname "$0")/../.."

nix run github:nix-community/nixos-anywhere -- \
  --flake .#server-media \
  --generate-hardware-config nixos-generate-config \
    ./hosts/server-media/hardware-configuration.nix \
  --extra-files "$EXTRA_FILES" \
  root@"$TARGET"
