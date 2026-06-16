# Hyprland Config Migration: Hyprlang -> Lua

## Goal
Migrate the entire Hyprland configuration from standard `.conf` (hyprlang) files to `.lua` files using the `hl` API. This enables more dynamic configuration, better organization, and programmatic control.

## Strategy
The migration follows a "Source -> Consolidated -> Lua" pattern:
1. **Sources**: The primary source of truth is `~/.dotfiles/sources/hypr/`.
2. **Consolidation**: Sourced fragments are combined into single, cohesive `.conf` files in `~/.claude/migration-stage/hypr/consolidated/`.
3. **Conversion**: The consolidated files are converted into `.lua` scripts in `~/.claude/migration-stage/hypr/` using the `hl` helper.

## Current State & Progress
All identified configuration areas have been mapped and converted.

| Component | Source File(s) | Lua Target | Status |
| :--- | :--- | :--- | :--- |
| Autostart | `sources/hypr/autostart.conf` | `autostart.lua` | Verified |
| Bindings | `sources/hypr/bindings/*.conf` | `bindings.lua` | Verified |
| Environment | `sources/hypr/envs.conf` | `envs.lua` | Verified |
| Look & Feel | `sources/hypr/looknfeel.conf` | `looknfeel.lua` | Verified |
| Window Rules | `sources/hypr/windows.conf` | `windows.lua` | Verified |
| Monitors | N/A (Standard) | `monitors.lua` | Verified |
| Input | N/A (Standard) | `input.lua` | Verified |
| Lockscreen | `consolidated/hyprlock.conf` | `hyprlock.lua` | Verified |
| Idle Daemon | `consolidated/hypridle.conf` | `hypridle.lua` | Verified |
| Sunset/Night | `consolidated/hyprsunset.conf` | `hyprsunset.lua` | Verified |
| XDG Portal | `consolidated/xdph.conf` | `xdph.lua` | Verified |

## Instructions for Future Agents
If you are tasked with continuing or updating this migration:
1. **Sourced Changes**: If changes are made to files in `~/.dotfiles/sources/hypr/`, you MUST update the corresponding `.lua` file in `~/.claude/migration-stage/hypr/`.
2. **Direct Lua Edits**: Prefer editing the `.lua` files directly for new features.
3. **Verification**: After any change, ensure the `migration_manifest.json` reflects the current status.
4. **Consistency**: Use the `hl` API consistently. Ensure `hl.config` is used for variable sets and `hl.bind` for shortcuts.

## History
- **2026-06-16**: Initial conversion of core files.
- **2026-06-16**: Conversion of specialized configs (`hyprlock`, `hypridle`, `hyprsunset`, `xdph`).
- **2026-06-16**: Final sync between `sources/hypr` and `.lua` files.
