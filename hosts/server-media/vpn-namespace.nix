{ config, pkgs, lib, ... }:
let
  ns = "vpn";
  wgIf = "wg-vpn";
  vpnAddress = "10.64.105.157/32";
  vpnDNS = "10.64.0.1";
  # Host <-> namespace bridge (veth pair) for forwarding the qBittorrent
  # web UI from the LAN into the namespace.
  hostVeth = "vpn-host";
  nsVeth = "vpn-ns";
  hostVethAddr = "10.99.0.1";
  nsVethAddr = "10.99.0.2";
  vethCidr = "30";
  qbitPort = 8083;
in
{
  age.secrets.mullvad-wg = {
    file = ../../secrets/mullvad-wg.conf.age;
    mode = "0400";
  };

  # 1. Create the network namespace.
  systemd.services."netns-${ns}" = {
    description = "Network namespace ${ns}";
    before = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip netns add ${ns}";
      ExecStop = "${pkgs.iproute2}/bin/ip netns del ${ns}";
    };
  };

  # DNS for processes inside the namespace.
  environment.etc."netns/${ns}/resolv.conf".text = "nameserver ${vpnDNS}\n";

  # 2. Bring up the WireGuard interface inside the namespace.
  systemd.services."wg-${ns}" = {
    description = "WireGuard tunnel inside ${ns} namespace";
    bindsTo = [ "netns-${ns}.service" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" "netns-${ns}.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.iproute2 pkgs.wireguard-tools ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ip link add ${wgIf} type wireguard
      ip link set ${wgIf} netns ${ns}
      ip -n ${ns} addr add ${vpnAddress} dev ${wgIf}
      ip netns exec ${ns} wg setconf ${wgIf} ${config.age.secrets.mullvad-wg.path}
      ip -n ${ns} link set ${wgIf} up
      ip -n ${ns} route add default dev ${wgIf}
      ip -n ${ns} link set lo up
    '';
    preStop = ''
      ip -n ${ns} link del ${wgIf} 2>/dev/null || true
    '';
  };

  # 3. Veth pair so the host LAN can reach qBittorrent's web UI inside the netns.
  systemd.services."veth-${ns}" = {
    description = "veth pair between host and ${ns} namespace";
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.iproute2 ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ip link add ${hostVeth} type veth peer name ${nsVeth}
      ip link set ${nsVeth} netns ${ns}
      ip addr add ${hostVethAddr}/${vethCidr} dev ${hostVeth}
      ip link set ${hostVeth} up
      ip -n ${ns} addr add ${nsVethAddr}/${vethCidr} dev ${nsVeth}
      ip -n ${ns} link set ${nsVeth} up
    '';
    preStop = ''
      ip link del ${hostVeth} 2>/dev/null || true
    '';
  };

  # 4. Forward host LAN :8083 to namespace's qBittorrent.
  systemd.services."qbit-webui-bridge" = {
    description = "Forward host:${toString qbitPort} to ${ns}:${toString qbitPort}";
    requires = [ "veth-${ns}.service" "qbittorrent.service" ];
    after = [ "veth-${ns}.service" "qbittorrent.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:${toString qbitPort},fork,reuseaddr,bind=0.0.0.0 TCP:${nsVethAddr}:${toString qbitPort}";
      Restart = "on-failure";
    };
  };

  # 5. Run qBittorrent inside the namespace.
  systemd.services.qbittorrent = {
    requires = [ "wg-${ns}.service" "veth-${ns}.service" ];
    after = [ "wg-${ns}.service" "veth-${ns}.service" ];
    serviceConfig = {
      NetworkNamespacePath = "/var/run/netns/${ns}";
      # qBittorrent's webUI must bind to the veth IP so the host bridge can reach it.
      BindReadOnlyPaths = [ "/etc/netns/${ns}/resolv.conf:/etc/resolv.conf" ];
    };
  };
}
