# compatible across all shells!
{
  config,
  lib,
  ...
}:

{
  options = {
    custom.hmAliases.enable = lib.mkEnableOption "enables Home Manager shell aliases";
    custom.hmAliasesAmdCpu.enable = lib.mkEnableOption "enables AMD CPU diagnostic shell aliases";
    custom.hmAliasesNvidiaGpu.enable = lib.mkEnableOption "enables NVIDIA GPU diagnostic shell aliases";
  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.hmAliases.enable {
      home.shellAliases = {
        ll = "ls -alF";
        verify = "nix-store --verify";
        trustedusers = "nix config show | grep trusted-users";
        checkall = "hostname && trustedusers";
        nixdiag = "journalctl -b -o short-monotonic > /tmp/_bootlog.txt; cat /proc/cmdline > /tmp/_bootparams.txt; journalctl -b | grep -i plymouth > /tmp/_plymouth.txt; sudo dmesg | grep -iE 'drm|amdgpu|fbcon|console' > /tmp/_drm_display_output_events.txt; journalctl -b | grep -i kscreen > /tmp/_kscreen.txt; journalctl -b -u display-manager | grep -iE 'kscreen|output|priority|primary' > /tmp/_display-manager.txt; journalctl -b -u greetd --no-pager > /tmp/_greetd.txt; journalctl -b --no-pager | grep -iE 'sway|wlroots|greetd|regreet' > /tmp/_greetd-sway.txt; cat /tmp/_bootlog.txt /tmp/_bootparams.txt /tmp/_plymouth.txt /tmp/_drm_display_output_events.txt /tmp/_kscreen.txt /tmp/_display-manager.txt /tmp/_greetd.txt /tmp/_greetd-sway.txt > /tmp/_results.txt; echo 'Diagnostics saved to /tmp/_results.txt'";

        # Nix workflow aliases
        switchcd = "cd ${config.home.homeDirectory}/git/nix-config";
        switchupdate = "cd ${config.home.homeDirectory}/git/nix-config && nix flake update";
        switchcheck = "cd ${config.home.homeDirectory}/git/nix-config && nix flake check";
      };
    })

    # AMD CPU diagnostic aliases (moved from modules/systems/nixos/cpu/amd.nix)
    (lib.mkIf config.custom.hmAliasesAmdCpu.enable {
      home.shellAliases = {
        amdmicrocode = "cat /proc/cpuinfo | grep microcode | uniq";
        sevcpu = "egrep -o 'sev|sev_es|sev_snp' /proc/cpuinfo | sort | uniq";
        sevkernel = "sudo dmesg | grep -i sev";
        sev = "ls -l /dev/sev";
        sevguest = "ls -l /dev/sev-guest";
        checkamdcpusupport = "amdmicrocode; sevcpu; sevkernel; sev; sevguest;";
      };
    })

    # NVIDIA GPU diagnostic aliases (moved from modules/systems/nixos/graphics/nvidia_rtx_3080.nix)
    (lib.mkIf config.custom.hmAliasesNvidiaGpu.enable {
      home.shellAliases = {
        gpuinfo = "nix-shell -p pciutils --run 'lspci -nn |grep -i vga'";

        openglinfo = "nix-shell -p glxinfo --run glxinfo |grep 'OpenGL renderer'";

        vlkinstalleddrivers = "echo '# start vlkinstalleddrivers start' && ls -alF /run/opengl-driver/share/vulkan/icd.d/ && echo '# end vlkinstalleddrivers end' && echo";
        vlkinfo = "nix-shell -p vulkan-tools --run 'vulkaninfo |grep deviceName'";
        vlkinfosummary = "nix-shell -p vulkan-tools --run 'vulkaninfo --summary'";
        vlkcube = "nix-shell -p vulkan-tools --run vkcube";
        checkallvulkan = "vlkinstalleddrivers; vlkinfo; vlkinfosummary;";

        # openclinfo = "nix-shell -p clinfo --run 'clinfo'";
        openclinfo = "nix-shell -p clinfo --run 'clinfo | head -n3'";

        vaapiinfo = "nix-shell -p libva-utils --run vainfo";
        vdpauinfo = "nix-shell -p vdpauinfo --run vdpauinfo";

        # checkblacklistedgpus = "lsmod |grep -E 'i915|amdgpu'";

        checkallgpufeatures = "gpuinfo; openglinfo; openclinfo; vaapiinfo; vdpauinfo;";
      };
    })
  ];
}
