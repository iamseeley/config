# Server-media deploy checklist

> The internal SSDs on this MacBook are inaccessible (T2 lockout / hardware
> issue). Installing to external USB drive instead. Single-disk install.

## Pre-deploy (do once)

1. Plug the LaCie HDD (labeled "media") into the target MacBook running
   the NixOS live installer.

2. Sign up for Tailscale (https://tailscale.com), generate a reusable auth key
   in admin console: Settings → Keys → Generate auth key.
   - Reusable: yes
   - Ephemeral: no
   - Tags: tag:server (create the tag first if needed)

3. Generate the SSH host key for the new server:
   ```
   ssh-keygen -t ed25519 -f /tmp/server-media-hostkey -N ""
   ```

4. Update `secrets.nix`: replace `media-server = null` with the contents of
   `/tmp/server-media-hostkey.pub` (just the key portion, no comment).

5. Encrypt the Tailscale auth key:
   ```
   cd ~/config
   nix run github:ryantm/agenix -- -e secrets/tailscale-authkey.age
   ```
   (Editor opens. Paste the auth key from step 2. Save. Exit.)

6. Set up extra-files for the host key:
   ```
   mkdir -p /tmp/server-media-extra-files/etc/ssh
   cp /tmp/server-media-hostkey \
      /tmp/server-media-extra-files/etc/ssh/ssh_host_ed25519_key
   cp /tmp/server-media-hostkey.pub \
      /tmp/server-media-extra-files/etc/ssh/ssh_host_ed25519_key.pub
   chmod 600 /tmp/server-media-extra-files/etc/ssh/ssh_host_ed25519_key
   ```

7. On the target MacBook, set up SSH access:
   - Add my laptop's pubkey to `~/.ssh/authorized_keys`, OR
   - Set a password: `sudo passwd nixos`
   - Get its IP: `ip addr` → note the LAN address

8. Verify SSH works from laptop: `ssh nixos@<mbp-ip>` (or `root@<mbp-ip>` if
   running as root in the installer).

9. Commit the host key change:
   ```
   git add -A
   git commit -m "add server-media host key"
   ```

## ⚠️ BEFORE DEPLOYING

The deploy will WIPE the drive at:
`/dev/disk/by-id/usb-LaCie_Rugged_USB-C_0000NT159P7X-0:0`
(1TB LaCie Rugged USB-C HDD, currently labeled "media")

If there's anything on it you want to keep, back it up FIRST.

To check what's on the LaCie from the target MacBook:
```bash
sudo mkdir -p /mnt/check
# Find the LaCie's partition(s) — likely /dev/sdb1 or similar
lsblk
# Then mount and inspect:
sudo mount /dev/sdb1 /mnt/check 2>/dev/null && ls /mnt/check
sudo umount /mnt/check 2>/dev/null
```

If that shows files you care about, stop and back them up.

## Deploy

```
cd ~/config
./hosts/server-media/deploy.sh <mbp-ip>
```

This takes 15-30 minutes. Watch for errors.

## Post-deploy

1. After reboot, SSH to the new server: `ssh tseeley@<mbp-ip>`
2. Verify services are running: `systemctl status jellyfin caddy tailscaled`
3. Check Tailscale joined the tailnet: `tailscale status`
4. Get the generated `hardware-configuration.nix` committed:
   ```
   cd ~/config
   git add hosts/server-media/hardware-configuration.nix
   git commit -m "add server-media hardware-configuration"
   ```
5. DNS: add A records pointing `jellyfin.seeley.me` and `request.seeley.me`
   at the MacBook's public IP (or set up dynamic DNS / Tailscale Funnel).
6. Verify TLS: `curl -I https://jellyfin.seeley.me` should return 200/302.
7. Initial Jellyfin setup via web UI.

## Follow-up rebuilds

```
nixos-rebuild switch --flake .#server-media \
  --target-host tseeley@<mbp-ip> \
  --use-remote-sudo
```

## Future work (separate commits)

- [ ] Set up Hetzner Storage Box, create restic-password.age and restic-env.age
- [ ] Uncomment restic block in media-stack.nix
- [ ] Add Unpackerr once upstream module merges (PR #509954)
- [ ] Configure Recyclarr profiles after Sonarr/Radarr API keys are known
- [ ] Set up agenix secrets for Sonarr/Radarr/SAB API keys
- [ ] DNS / external access strategy (port forward vs Cloudflare Tunnel vs Tailscale Funnel)
