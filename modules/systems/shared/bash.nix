{
  config,
  lib,
  ...
}:

{
  options = {
    custom.bashCompletion.enable = lib.mkEnableOption "enables system-level bash completion";
  };

  config = lib.mkIf config.custom.bashCompletion.enable {
    programs.bash.completion.enable = true;
  };
}
