# Mullvad VPN daemon
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/mullvad.nix ];
#   custom.sysNixMullvad.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixMullvad.enable = lib.mkEnableOption "enables Mullvad VPN daemon";
  };

  config = lib.mkIf config.custom.sysNixMullvad.enable {
    services.mullvad-vpn.enable = true;

    # WireGuard-based kill-switch requires loose reverse-path filtering.
    # Without this, packets routed through the WireGuard tunnel are
    # dropped by the kernel's strict rp_filter check.
    # See: https://nixos.wiki/wiki/Mullvad_VPN
    networking.firewall.checkReversePath = lib.mkDefault "loose";
  };
}
