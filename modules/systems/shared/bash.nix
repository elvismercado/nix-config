{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysBashCompletion.enable = lib.mkEnableOption "enables system-level bash completion";
  };

  config = lib.mkIf config.custom.sysBashCompletion.enable {
    programs.bash.completion.enable = true;
  };
}
