# PipeWire — modern audio/video server replacing PulseAudio and JACK
#
# Provides low-latency audio with PulseAudio and ALSA compatibility.
# 32-bit ALSA support is included for Steam and other 32-bit applications.
# rtkit grants PipeWire realtime scheduling priority for glitch-free audio.
#
# Usage:
#   imports = [ ../../../modules/systems/nixos/pipewire.nix ];
#   custom.sysNixPipewire.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysNixPipewire.enable = lib.mkEnableOption "enables PipeWire audio server";
  };

  config = lib.mkIf config.custom.sysNixPipewire.enable {
    # Realtime scheduling for audio — prevents crackling and dropouts
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
