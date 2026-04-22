{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixLibvirtd.enable = lib.mkEnableOption "enables libvirtd virtualisation and virt-manager";
  };

  config = lib.mkIf config.custom.sysNixLibvirtd.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
