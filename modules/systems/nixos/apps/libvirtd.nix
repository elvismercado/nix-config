# Libvirtd — QEMU/KVM virtualisation with virt-manager
#
# Automatically adds the user to the libvirtd group.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/apps/libvirtd.nix ];
#   custom.sysNixLibvirtd.enable = true;

{
  config,
  lib,
  userSettings,
  ...
}:

{
  options = {
    custom.sysNixLibvirtd.enable = lib.mkEnableOption "libvirtd QEMU/KVM virtualisation with virt-manager";
  };

  config = lib.mkIf config.custom.sysNixLibvirtd.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    users.users.${userSettings.username}.extraGroups = [ "libvirtd" ];
  };
}
