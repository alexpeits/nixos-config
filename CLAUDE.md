# nixos-config

Personal Nix configuration for one NixOS laptop, two macOS home-manager setups and a
non-NixOS (Debian) home-manager setup. Everything targets **nixpkgs 26.05**.

## Entry points

| Target | Defined in | Build / switch |
|---|---|---|
| NixOS laptop `seabeast` (x86_64-linux, xmonad) | `flake.nix` → `nixosConfigurations.seabeast` | `bin/nixos b` / `bin/nixos s` (= `sudo nixos-rebuild test/switch --flake "$NIXOS_CONFIG#"`) |
| Debian home-manager (x86_64-linux) | `flake.nix` → `homeConfigurations.debian` | `make -C debian build` / `switch` |
| macOS personal (aarch64-darwin) | `mac/flake.nix` → `homeConfigurations.macbook-home` | `hm b` / `hm s` (= `make -C mac build/switch`, uses `$HOME_MANAGER_NAME`) |
| macOS work (aarch64-darwin) | `mac/flake.nix` → `homeConfigurations.macbook-work` | same as above |
| NixOS without flakes (fallback) | `assets/root-configuration.nix` (copy to `/etc/nixos/configuration.nix`) + niv | `sudo nixos-rebuild switch` |

DevShells with the `home-manager` CLI: `nix develop` (Linux, root flake), `nix develop ./mac`.
`mac/shell.nix` and `debian/shell.nix` are thin `nix-shell` wrappers around those devShells.

There are **two flakes with separate lock files**: the root one (NixOS + Debian) and `mac/`
(it reaches into `../home` etc., which works because the whole repo is copied to the store).

## Layout

- `flake.nix`, `flake.lock` — NixOS + Debian. Inputs: `nixpkgs`, `home-manager` only.
- `configuration.nix` — NixOS top-level module; imports `nix/`, `system/*`, `hardware-configuration.nix`,
  and installs `packages/` system-wide.
- `hardware-configuration.nix` — generated-style hardware config for `seabeast` (imports `not-detected.nix`).
- `system/` — NixOS modules: boot/LUKS, audio (PipeWire), printing, desktop (LightDM + xmonad,
  `sessionCommands`), fonts, input (xkb, libinput, wacom), networking, power (tlp, `acpi_call`
  for `tpacpi-bat`), user, docker.
- `nix/default.nix` — Nix daemon settings (`nix.settings.*`, caches, `channel.enable = false`; NIX_PATH and
  registry come from the flake), `stateVersion`.
- `nix/sources.{json,nix}` — **niv** pins, only for the non-flake path (`nix/home-manager.nix`,
  `assets/root-configuration.nix`) and the fish `nsu` function. `nix/home-manager.nix` is the niv
  equivalent of the flake's home-manager module.
- `nix/lib.nix` — small helpers (`template`, `is-mac`); currently unused.
- `home/`
  - `common.nix` — shared home-manager config (git, fish, bash, zsh + oh-my-zsh, fzf, direnv, bat,
    dotfiles in `~`). Imported by every target.
  - `nixos.nix` — NixOS user: systemd user services (keyboard, xautolock, xss-lock, wiki, notes-git-push
    timer), dunst, udiskie, rofi, gnome-terminal profiles.
  - `linux.nix` — non-NixOS Linux base (used by `debian/home.nix`); largely duplicates `nixos.nix`.
  - `mac.nix`, `home-extra.nix` (Haskell toolchain, slow), `work-extra.nix`, `mac-extra.nix` (texlive, not enabled).
- `debian/` — `home.nix` (imports `home/linux.nix`, `targets.genericLinux`), `Makefile`, `bootstrap`
  (root script writing xorg/tlp/chrome config to `/etc`), notes.
- `dotfiles/` — shell rc fragments and scripts as Nix strings/functions (`scripts.nix`, `zshrc.nix`,
  `fishrc.nix`, `bashrc.nix`, `tmux-conf.nix`, `vim.nix`, `profile.nix` aliases + `path`, …).
- `packages/` — `default.nix` is the NixOS system package list (also installed on Debian);
  `haskell/` (nixpkgs Haskell tools + `ghc.nix` version-suffixed GHC wrapper); `tools/` small local
  derivations (kbconfig, trayer-wrap, i3lock-wrap, xmonad-build, tpacpi-bat); `emacs.nix` (custom Emacs
  27 build, unused); `apps/aseprite`.
- `archived/` — old packages kept for reference; not imported.
- `assets/` — wallpapers, colors, `root-configuration.nix`.

## Conventions

- **Pin inputs to commit hashes in the URL** (e.g. `github:nixos/nixpkgs/<rev>`), not branches. To update:
  change the hash, then `nix flake lock`. Keep the root flake, `mac/flake.nix` and the niv `nixos` /
  `home-manager` entries on the same revisions.
- niv: `niv update <name> -r <rev>`. Without a `GITHUB_TOKEN`, branch lookups hit the GitHub API rate
  limit; resolve heads with `git ls-remote https://github.com/<owner>/<repo> refs/heads/<branch>`.
- Use `pkgs.stdenv.hostPlatform.isDarwin` for platform checks. Don't add overlays or `nixpkgs.config`
  to home-manager modules: the flakes pass in a pre-imported `pkgs` with `allowUnfree`, and setting
  `nixpkgs.*` in home-manager forces a second nixpkgs import.
- Use top-level X packages (`pkgs.xset`, `pkgs.xsetroot`, `pkgs.xmessage`, `pkgs.setxkbmap`); `pkgs.xorg.*`
  is deprecated.
- **Do not delete files or scripts just because they look unused** (`dotfiles/scripts.nix` entries,
  `debian/`, `home/linux.nix`, `dotfiles/autostart.nix`, `archived/`, …). Fix them in place, or ask.
- Formatting: `nixpkgs-fmt` (don't run it on the generated `nix/sources.nix`).
- Hardcoded identity: user `alex` / `/home/alex` on Linux, `alexpeits` / `/Users/alexpeits` on macOS;
  `$NIXOS_CONFIG` points at the repo checkout.

## Verifying changes

The usual dev machine is the Mac, so Linux targets can be evaluated but not built. Evaluating is the minimum check:

```sh
nix eval --raw .#nixosConfigurations.seabeast.config.system.build.toplevel.drvPath
nix eval --raw .#homeConfigurations.debian.activationPackage.drvPath
(cd mac && nix eval --raw .#homeConfigurations.macbook-work.activationPackage.drvPath)
(cd mac && nix eval --raw .#homeConfigurations.macbook-home.activationPackage.drvPath)
nix flake check --no-build --all-systems
```

New files must be `git add`ed before flakes can see them. Check that evaluation prints no `evaluation warning:` lines.
The non-flake path can be checked by evaluating `(import (sources.nixos + "/nixos") { system = "x86_64-linux"; configuration = …; })`
with a copy of `assets/root-configuration.nix` whose `/home/alex/nixos-config` paths point at the checkout.

## Potential future fixes

Known issues and loose ends, roughly by priority:

- **Linux has only been evaluated since the 22.05 → 26.05 jump, never built.** Behaviour changes to verify on hardware:
  - LightDM replaces GDM, because GDM no longer runs X11 sessions.
  - PipeWire replaces `pulseaudioFull`.
  - powertop auto-tune is off, so tlp alone manages power.
  - Emacs 30 replaces Emacs 28.
  - `acpi_call` is now loaded directly in `system/power.nix`.
- **Packages dropped for security:**
  - `tmate` was removed from the system packages because it's marked insecure (CVE-2018-19387). `.tmate.conf` is still generated.
  - logseq was removed because it depends on an EOL Electron.
  - Re-adding either needs `nixpkgs.config.permittedInsecurePackages`.
- `packages/emacs.nix` builds Emacs 27.0.90 from git on top of the current Emacs recipe (`lib.drop 1 old.patches`).
  It evaluates but almost certainly won't build. It's unused, and was deliberately left as is.
- `dotfiles/scripts.nix` `em`/`magit` use plain `pkgs.emacs`, while the system installs Emacs with `vterm` and
  `agda2-mode`. The daemons they start won't have those packages.
- `home/linux.nix` and `home/nixos.nix` duplicate about 60 lines: the keyboard service, mimeApps, rofi and the
  gnome-terminal dark profiles. `nixos.nix` could import `linux.nix`.
- `debian/home.nix` installs the whole NixOS desktop package list (`packages/`, including agda, coq, lilypond and steam-run).
- `debian/bootstrap` duplicates settings from `system/` (xkb, libinput, tlp) by hand, so they can drift.
- Three pinning sources must be kept in sync by hand: the root flake, `mac/flake.nix` and niv. A single root flake
  that also exposes the macOS `homeConfigurations` would remove one lock file, `mac/Makefile` and the
  `HOME_MANAGER_NAME` indirection.
- `nix/default.nix` lists `@sudo` in `trusted-users`, but that group doesn't exist on NixOS. It also has public keys
  for `alexpeits-gh-actions` and `ghcide-nix` without matching substituters.
- `system/default.nix` refers to the LUKS device as `/dev/sda6`. A `/dev/disk/by-uuid/…` path would be more robust.
- `programs.git` uses `credential.helper = "store"`, which keeps tokens in plaintext. On macOS, `osxkeychain` would be better.
- Three shells are fully configured: fish (with plugins), bash and zsh (with oh-my-zsh, loaded for just the `git` plugin).
  Trimming the unused ones would reduce maintenance and zsh startup time.
- `nixpkgs-fmt` is unmaintained. `nixfmt` (RFC style) is the nixpkgs standard now, but switching would reformat everything.
- `nix/lib.nix` and `dotfiles/autostart.nix` (an XFCE-only autostart) aren't imported anywhere.
- README install instructions predate flakes in places, such as the dual-boot GRUB snippet. They have been updated but not re-tested.
