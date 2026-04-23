# Ansible — IT automation toolkit and linter
#
# Installs ansible (includes ansible-playbook, ansible-vault, ansible-galaxy,
# etc.) and ansible-lint. All binaries are on PATH via Nix — no pip or
# ~/.local/bin needed.
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/ansible.nix ];
#   custom.hmAnsible.enable = true;

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.hmAnsible.enable = lib.mkEnableOption "Ansible IT automation toolkit and ansible-lint";
  };

  config = lib.mkIf config.custom.hmAnsible.enable {
    home.packages = with pkgs; [
      ansible
      ansible-lint
    ];
  };
}
