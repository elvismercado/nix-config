---
description: "Scaffold a new Nix module with the custom.*.enable pattern. Use when adding a system or home-manager module."
agent: "agent"
argument-hint: "Module name, scope (nixos/hm-all/hm-linux/etc.), and which hosts to enable it on"
---

Create a new module following the [project conventions](../copilot-instructions.md).

## 1. Gather requirements

If not provided, ask for:

- **Module name** — short, descriptive (e.g., "bluetooth", "gaming")
- **Scope** — where the module lives:
  - `modules/systems/nixos/` — NixOS system module
  - `modules/systems/nixos/<subdir>/` — NixOS module in a subdirectory (e.g., `apps/`, `gaming/`, `memory/`)
  - `modules/systems/darwin/` — nix-darwin system module
  - `modules/systems/shared/` — cross-platform system module
  - `modules/home-manager/all/` — home-manager module for all platforms
  - `modules/home-manager/linux/` — home-manager module for Linux only
  - `modules/home-manager/darwin/` — home-manager module for macOS only
- **Enable option name** — e.g., `custom.bluetooth.enable` (system) or `custom.hmGaming.enable` (home-manager)
- **One-line purpose** — for the comment header
- **Target hosts** — which hosts to import and enable the module on (e.g., FENNEC, JIN, EDGE)

## 2. Create the module file

Use the standard module template. Follow the existing patterns:

- System modules: [bluetooth.nix](../../modules/systems/nixos/bluetooth.nix)
- Home-manager modules: [gaming.nix](../../modules/home-manager/linux/gaming.nix)

The file must contain:

1. **Comment header** — one-line purpose, brief explanation, and `Usage:` block showing the import path and enable flag
2. **Function arguments** — `{ config, lib, ... }:` (add `pkgs` only if needed)
3. **Options block** — `options.custom.<name>.enable = lib.mkEnableOption "description";`
4. **Config block** — `config = lib.mkIf config.custom.<name>.enable { };` with an empty body

Leave the config body empty — tell the user to fill it in.

When a module option could be derived from existing NixOS config (e.g., swap UUID from `swapDevices`, hostname from `networking.hostName`), make the option optional with a `null` default and auto-derive. Add an assertion for clear errors when auto-derivation fails and no explicit value is provided.

## 3. Wire into host(s)

For each target host:

1. Add the import to `hosts/<HOST>/configuration/default.nix` (system modules) or `hosts/<HOST>/home-manager/default.nix` (home-manager modules)
2. Add `custom.<name>.enable = true;` under the appropriate category comment
3. Follow the existing category ordering in the file (Nix, Bootloader, Hardware, Memory, System, Display, Peripherals, Services, Apps, Gaming, etc.)
4. If no matching category exists, add a new category comment in a logical position

## 4. Update documentation

Add a row to the correct module table:

- NixOS / shared system modules → `NIXOS.md`
- Home-manager modules → `HOME-MANAGER.md`
- Darwin system modules → `DARWIN.md`

Row format: `| <module-path> | custom.<name>.enable |`

Insert the row in the correct category section of the table, maintaining alphabetical order within the category.

## 5. Remind the user

After scaffolding, print:

> Module scaffolded. Fill in the `config` block in `<path>` with the actual Nix configuration.
