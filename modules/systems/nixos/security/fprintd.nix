{
  config,
  lib,
  ...
}:

{
  options = {
    custom.fprintd.enable = lib.mkEnableOption "enables fingerprint reader support";
  };

  config = lib.mkIf config.custom.fprintd.enable {
    services.fprintd.enable = true;

    # Enroll fingerprints with: fprintd-enroll
    # Verify with: fprintd-verify
    # Once enrolled, fingerprint auth works for login, sudo, and polkit prompts
  };
}
