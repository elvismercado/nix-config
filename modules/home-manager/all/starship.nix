# Starship — cross-platform shell prompt
# https://starship.rs
#
# Fast, minimal, and customizable prompt with git integration.
# Works on Linux, macOS, and Windows.
#
# Styles:
#   "default"          — user@host  ~/path  (branch)  =>
#   "pastel-powerline" — powerline segments with pastel colors (requires Nerd Font)
#
# Usage:
#   imports = [ ../../../modules/home-manager/all/starship.nix ];
#   custom.hmStarship.enable = true;
#   custom.hmStarship.style = "pastel-powerline";  # or "default"

{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.hmStarship;

  # ── Default style ──────────────────────────────────────────────────
  # Clean two-line prompt: user@host dir (branch) / => on next line
  defaultSettings = {
    add_newline = false;

    format = lib.concatStrings [
      "$username"
      "@"
      "$hostname"
      " "
      "$directory"
      " "
      "$git_branch"
      "$git_status"
      "$cmd_duration"
      "\n"
      "$character"
    ];

    username = {
      show_always = true;
      format = "[$user]($style)";
      style_user = "bold cyan";
    };

    hostname = {
      ssh_only = false;
      format = "[$hostname]($style)";
      style = "bold cyan";
    };

    directory = {
      truncation_length = 5;
      format = "[$path]($style)";
      style = "bold green";
    };

    git_branch = {
      format = "[$symbol$branch]($style) ";
      symbol = " ";
      style = "bold yellow";
    };

    git_status = {
      format = "[$all_status$ahead_behind]($style)";
      style = "bold yellow";
    };

    cmd_duration = {
      min_time = 2000;
      format = "took [$duration]($style) ";
      style = "bold yellow";
    };

    character = {
      success_symbol = "[=>](bold green)";
      error_symbol = "[=>](bold red)";
    };
  };

  # ── Pastel Powerline style ────────────────────────────────────────
  # Colored powerline segments with arrow separators (requires Nerd Font)
  # Based on https://starship.rs/presets/pastel-powerline
  # Palette: purple → pink → peach → blue → dark blue
  pastelPowerlineSettings = {
    format = lib.concatStrings [
      "[](#9A348E)"
      "$os"
      "$username"
      "[@](bg:#9A348E fg:#FFFFFF)"
      "$hostname"
      "[](bg:#DA627D fg:#9A348E)"
      "$directory"
      "[](fg:#DA627D bg:#FCA17D)"
      "$git_branch"
      "$git_status"
      "[](fg:#FCA17D bg:#86BBD8)"
      "$nodejs"
      "$rust"
      "$nix_shell"
      "[](fg:#86BBD8 bg:#06969A)"
      "$docker_context"
      "[](fg:#06969A bg:#33658A)"
      "$cmd_duration"
      "$time"
      "[ ](fg:#33658A)"
      "\n"
      "$character"
    ];

    os = {
      style = "bg:#9A348E fg:#FFFFFF";
      disabled = false;
    };

    username = {
      show_always = true;
      style_user = "bg:#9A348E fg:#FFFFFF";
      style_root = "bg:#9A348E fg:#FFFFFF";
      format = "[$user]($style)";
    };

    hostname = {
      ssh_only = false;
      style = "bg:#9A348E fg:#FFFFFF";
      format = "[$hostname ]($style)";
    };

    directory = {
      style = "bg:#DA627D fg:#FFFFFF";
      format = "[ $path ]($style)";
      truncation_length = 0; # full path
      truncation_symbol = "…/";
      substitutions = {
        Documents = "󰈙 ";
        Downloads = " ";
        Music = " ";
        Pictures = " ";
      };
    };

    git_branch = {
      symbol = "";
      style = "bg:#FCA17D fg:#111111";
      format = "[ $symbol $branch ]($style)";
    };

    git_status = {
      style = "bg:#FCA17D fg:#111111";
      format = "[$all_status$ahead_behind ]($style)";
    };

    nodejs = {
      symbol = "";
      style = "bg:#86BBD8 fg:#111111";
      format = "[ $symbol ($version) ]($style)";
    };

    rust = {
      symbol = "";
      style = "bg:#86BBD8 fg:#111111";
      format = "[ $symbol ($version) ]($style)";
    };

    nix_shell = {
      symbol = " ";
      style = "bg:#86BBD8 fg:#111111";
      format = "[ $symbol$state ]($style)";
    };

    docker_context = {
      symbol = " ";
      style = "bg:#06969A fg:#FFFFFF";
      format = "[ $symbol $context ]($style)";
    };

    cmd_duration = {
      min_time = 2000;
      style = "bg:#33658A fg:#FFFFFF";
      format = "[ took $duration ]($style)";
    };

    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:#33658A fg:#FFFFFF";
      format = "[ $time ]($style)";
    };

    character = {
      success_symbol = "[=>](bold green)";
      error_symbol = "[=>](bold red)";
    };
  };

  styleSettings = {
    "default" = defaultSettings;
    "pastel-powerline" = pastelPowerlineSettings;
  };
in
{
  options = {
    custom.hmStarship.enable = lib.mkEnableOption "enables Starship cross-platform shell prompt";

    custom.hmStarship.style = lib.mkOption {
      type = lib.types.enum [
        "default"
        "pastel-powerline"
      ];
      default = "default";
      description = "Starship prompt style. 'default' is a clean two-line prompt; 'pastel-powerline' uses colored powerline segments (requires Nerd Font).";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = styleSettings.${cfg.style};
    };
  };
}
