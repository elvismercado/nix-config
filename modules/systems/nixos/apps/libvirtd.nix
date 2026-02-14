{
  config,
  lib,
  ...
}:

{
  options = {
    custom.libvirtd.enable = lib.mkEnableOption "enables libvirtd virtualisation and virt-manager";
  };

  config = lib.mkIf config.custom.libvirtd.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
