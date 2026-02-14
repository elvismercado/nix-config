---
description: "Audit all documentation against the current repo structure. Use when modules, hosts, or scripts have been added, removed, or renamed."
agent: "Plan"
argument-hint: "Describe what changed (e.g. 'added gaming modules', 'new host FENNEC')"
---

Audit all documentation in this repository against the actual codebase. Follow the [project conventions](../copilot-instructions.md).

## 1. Discover the current state

Use subagents to gather these in parallel:

- **Hosts**: Read `flake/hosts.nix` — extract all host names from `nixosHosts`, `darwinHosts`
- **NixOS modules**: List all `.nix` files under `modules/systems/nixos/` and `modules/systems/shared/`. For each, extract the `custom.*.enable` option name from the `options` block.
- **Home Manager modules**: List all `.nix` files under `modules/home-manager/`. For each, extract the `custom.*.enable` option name.
- **Darwin modules**: List all `.nix` files under `modules/systems/darwin/`.
- **Scripts**: List files under `scripts/nixos/`.

## 2. Read all documentation files

- `README.md` — title, hosts table, quick commands, repository structure tree
- `NIXOS.md` — hosts table, rebuild commands, available module table
- `HOME-MANAGER.md` — hosts table, switch commands, module tables (all/linux/darwin)
- `DARWIN.md` — hosts table, rebuild commands, available module table
- `scripts/nixos/INSTALL.md` — install and post-install steps
- Host READMEs: `hosts/*/README.md`

## 3. Cross-reference

For each doc file, check:

- Every host in `flake/hosts.nix` appears in the appropriate hosts tables
- Every module appears in the corresponding module table with its correct `custom.*.enable` option name
- Quick commands and rebuild examples include all current hosts
- Repository structure tree in `README.md` reflects the actual directory layout
- No references to renamed, deleted, or non-existent files remain

## 4. Check instruction files

- `.github/copilot-instructions.md` — project structure, host wiring, module conventions
- `.github/instructions/*.instructions.md` — constraints match current codebase

## 5. Report findings

For each file, produce a table:

| File              | Section             | Issue                                   | Priority             |
| ----------------- | ------------------- | --------------------------------------- | -------------------- |
| `NIXOS.md`        | Hosts table         | Missing FENNEC                          | P1 — missing host    |
| `HOME-MANAGER.md` | All platforms table | Missing `fnm.nix` (`custom.fnm.enable`) | P2 — missing module  |
| `README.md`       | Structure tree      | `gaming/` directory not shown           | P3 — stale structure |

Priority levels:

- **P1**: Missing hosts
- **P2**: Missing or incorrect modules
- **P3**: Stale references, outdated structure, cosmetic

If a file needs no changes, state: `✅ <filename> — no changes needed`.
