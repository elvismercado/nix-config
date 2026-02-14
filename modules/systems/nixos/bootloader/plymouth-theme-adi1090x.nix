# adi1090x Plymouth Themes — 80 themes ported from Android boot animations
# https://github.com/adi1090x/plymouth-themes
#
# Only the selected theme is installed to avoid downloading all ~524 MB.
# GIF previews: https://github.com/adi1090x/plymouth-themes#previews
#
# Available themes (organized by upstream pack):
#
#   Pack 1:
#     abstract_ring, abstract_ring_alt, alienware, angular, angular_alt,
#     black_hud, blockchain, circle, circle_alt, circle_flow,
#     circle_hud, circuit, colorful, colorful_loop, colorful_sliced,
#     connect, cross_hud, cubes, cuts, cuts_alt
#
#   Pack 2:
#     cyanide, cybernetic, dark_planet, darth_vader, deus_ex,
#     dna, double, dragon, flame, glitch,
#     glowing, green_blocks, green_loader, hexagon, hexagon_2,
#     hexagon_alt, hexagon_dots, hexagon_dots_alt, hexagon_hud, hexagon_red
#
#   Pack 3:
#     hexa_retro, hud, hud_2, hud_3, hud_space,
#     ibm, infinite_seal, ironman, liquid, loader,
#     loader_2, loader_alt, lone, metal_ball, motion,
#     optimus, owl, pie, pixels, polaroid
#
#   Pack 4:
#     red_loader, rings, rings_2, rog, rog_2,
#     seal, seal_2, seal_3, sliced, sphere,
#     spin, spinner_alt, splash, square, square_hud,
#     target, target_2, tech_a, tech_b, unrap
#
# Usage:
#   imports = [
#     ../../../modules/systems/nixos/bootloader/plymouth.nix
#     ../../../modules/systems/nixos/bootloader/plymouth-theme-adi1090x.nix
#   ];
#   custom.plymouth.enable = true;
#   custom.plymouthThemeAdi1090x.enable = true;
#   custom.plymouthThemeAdi1090x.theme = "angular_alt";
# My Favourites:
#   - angular_alt (Pack 1)
#   - circuit (Pack 1)
#   - cubes (Pack 1)
#   - deus_ex (Pack 2)
#   - flame (Pack 2)
#   - hexagon_alt (Pack 2)
#   - hud_3 (Pack 3)
#   - metal_ball (Pack 3)
#   - pixels (Pack 3)
#   - rings_2 (Pack 4)
#   - seal_2 (Pack 4)
#   - square (Pack 4)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    custom.plymouthThemeAdi1090x.enable = lib.mkEnableOption "enables an adi1090x Plymouth theme";

    custom.plymouthThemeAdi1090x.theme = lib.mkOption {
      type = lib.types.enum [
        # Pack 1
        "abstract_ring"
        "abstract_ring_alt"
        "alienware"
        "angular"
        "angular_alt"
        "black_hud"
        "blockchain"
        "circle"
        "circle_alt"
        "circle_flow"
        "circle_hud"
        "circuit"
        "colorful"
        "colorful_loop"
        "colorful_sliced"
        "connect"
        "cross_hud"
        "cubes"
        "cuts"
        "cuts_alt"
        # Pack 2
        "cyanide"
        "cybernetic"
        "dark_planet"
        "darth_vader"
        "deus_ex"
        "dna"
        "double"
        "dragon"
        "flame"
        "glitch"
        "glowing"
        "green_blocks"
        "green_loader"
        "hexagon"
        "hexagon_2"
        "hexagon_alt"
        "hexagon_dots"
        "hexagon_dots_alt"
        "hexagon_hud"
        "hexagon_red"
        # Pack 3
        "hexa_retro"
        "hud"
        "hud_2"
        "hud_3"
        "hud_space"
        "ibm"
        "infinite_seal"
        "ironman"
        "liquid"
        "loader"
        "loader_2"
        "loader_alt"
        "lone"
        "metal_ball"
        "motion"
        "optimus"
        "owl"
        "pie"
        "pixels"
        "polaroid"
        # Pack 4
        "red_loader"
        "rings"
        "rings_2"
        "rog"
        "rog_2"
        "seal"
        "seal_2"
        "seal_3"
        "sliced"
        "sphere"
        "spin"
        "spinner_alt"
        "splash"
        "square"
        "square_hud"
        "target"
        "target_2"
        "tech_a"
        "tech_b"
        "unrap"
      ];
      default = "angular_alt";
      description = "adi1090x Plymouth theme to use (see https://github.com/adi1090x/plymouth-themes#previews)";
    };
  };

  config = lib.mkIf config.custom.plymouthThemeAdi1090x.enable {
    boot.plymouth = {
      theme = config.custom.plymouthThemeAdi1090x.theme;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ config.custom.plymouthThemeAdi1090x.theme ];
        })
      ];
    };
  };
}
