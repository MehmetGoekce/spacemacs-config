# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Spacemacs user configuration (`~/.spacemacs.d`, the `dotspacemacs-directory`), forked from [practicalli/spacemacs-config](https://github.com/practicalli/spacemacs-config) and extended with C/C++, Go, Java, PHP, Python and DAP layers. Spacemacs itself lives in `~/.emacs.d` (on the `develop` branch) and is not part of this repo. Emacs is a source build at `/usr/local/bin/emacs` (30.0.50).

`README.md` and `CHANGELOG.md` are largely inherited from upstream Practicalli and partly out of date (e.g. the README lists `org-config.el` as loaded; it is not). Trust `init.el` over the README.

## Commands

There is no build, lint or test suite. Two checks work outside a running Emacs.

Paren/read check of a single file (fast, no side effects):

```bash
emacs --batch --eval '(with-temp-buffer (insert-file-contents "init.el") (emacs-lisp-mode) (check-parens))'
```

Note that `check-parens` does not catch a broken first line or stray top-level symbols; a file can pass it and still fail to load.

Full startup of Spacemacs with this configuration (about a minute), printing only startup errors:

```bash
cd ~ && emacs --batch -l ~/.emacs.d/init.el 2>&1 | grep -a "^Error\|(Spacemacs) Err"
```

This is a real startup: it installs missing packages and deletes orphaned ones exactly as the GUI would (`dotspacemacs-install-packages 'used-only`). Append `-l some-check.el` to inspect state afterwards (open a file, check `major-mode`, `require` a package). Font-lock and LSP do not start in batch mode, so use `font-lock-ensure` to test highlighting.

Do not byte-compile the `*-config.el` files or load them on their own: they depend on Spacemacs functions (`spacemacs/set-leader-keys`, `evil-global-set-key`, ...) that only exist inside a full Spacemacs session.

Changes take effect inside Emacs:

- `SPC f e R` — reload the dotfile (sufficient for most layer variable and `user-config` changes; installs newly added layers/packages)
- `SPC q r` — restart Emacs (needed when removing layers or changing `dotspacemacs/init` settings)
- `, e e` — evaluate the expression before point, for testing a single form in a `*-config.el` file

## Architecture

`init.el` defines the standard Spacemacs lifecycle functions, called in this order:

1. `dotspacemacs/layers` — layer list with per-layer `:variables`, plus `dotspacemacs-additional-packages`. Almost all package configuration lives here as layer variables rather than in `user-config`.
2. `dotspacemacs/init` — Spacemacs core settings (theme, font, editing style, banner). This is the stock template with its full comment block; keep the comments when editing.
3. `dotspacemacs/user-env` — loads `.spacemacs.env`.
4. `dotspacemacs/user-init` — redirects `custom-file` to `emacs-custom-settings.el` and loads it with `'noerror`.
5. `dotspacemacs/user-config` — contains no configuration itself; it only `load`s the split-out files below.

### Split user-config files

`dotspacemacs/user-config` loads these, in order: `user-config.el`, `clojure-config.el`, `theme-config.el`, `version-control-config.el`. Each is plain top-level elisp evaluated after all layers are configured.

`org-config.el` and `eshell-config.el` exist but their `load` calls are commented out — edits to them have no effect until re-enabled in `init.el`. `deprecated-config.el` is never loaded; it is an archive of retired snippets.

To add a new area of configuration, create a `<topic>-config.el` and add a `setq` + `load` pair to `dotspacemacs/user-config` following the existing pattern.

### Settings that span files

- **lsp-ui doc/sideline**: disabled globally in the `lsp` layer variables in `init.el`, then re-enabled buffer-locally for C/C++ via a `c-mode-common-hook` in `user-config.el`. Changing one without the other breaks the intended "minimal UI except in C/C++" behaviour.
- **Org TODO workflow**: `org-journal-carryover-items` in the `org` layer variables references the `DOING`/`BLOCKED`/`REVIEW` keywords that are only defined in the (currently unloaded) `org-config.el`.
- **`clojure-essential-ref`** and **`combobulate`** are installed through `dotspacemacs-additional-packages`; the keybindings for the former are in `clojure-config.el`. `evil-surround` is pinned to a specific commit there on purpose.
- **CUDA**: `cuda-mode` (also in `dotspacemacs-additional-packages`) handles `.cu`/`.cuh` and derives from `c++-mode`, so the `c++-mode` hooks and the C/C++ lsp-ui hook apply and clangd accepts it. The `c-c++` layer's `,` major-mode bindings are registered for `c-mode`/`c++-mode` only and are absent in `cuda-mode`; tree-sitter has no CUDA grammar, so highlighting comes from cc-mode font-lock. The toolchain is CUDA 12.6 in `/usr/local/cuda` (`nvcc`, `cuda-gdb`); clangd is 14, which predates it.

### Keybinding conventions

User bindings go under the `SPC o` prefix (reserved by Spacemacs for users), e.g. `SPC o p p` for Portal. Major-mode bindings use `spacemacs/set-leader-keys-for-major-mode` (reached via `,`).

## Troubleshooting startup

- **"Pick your editing style for recovery"** at startup means `init.el` failed to load (syntax error or a stray top-level form). Fix the file; nothing else is wrong.
- **`(Spacemacs) Error in dotspacemacs/init: Variable ... doesn't match its type`**: Spacemacs validates `dotspacemacs-*` values against the current template, so a value that was valid in an older Spacemacs can be rejected after an update.
- **After updating Spacemacs (`git pull` in `~/.emacs.d`)**, errors like `Assertion failed: (listp args)` in a `use-package` `:config` usually come from Spacemacs-local packages (`layers/**/local/<name>`) whose built copy in `~/.emacs.d/elpa/<version>/develop/<name>-<date>/` is older than the layer source. Remove the stale directory and start Spacemacs; it rebuilds the package.
- **`failed to provide feature` or `void-variable` on loading a package** points to a truncated or stale `.elc` (compiled while a dependency was missing). Recompile the file inside a full Spacemacs batch session, with the dependency loaded first.
- Warnings from background native compilation are logged to `*Warnings*` without popping it up (`native-comp-async-report-warnings-errors 'silent` in `dotspacemacs/user-init`).
- `sudo` needs a password and cannot be run from Claude Code; system packages must be installed by the user in a terminal.

## Files that are not source

- `emacs-custom-settings.el` — written by Emacs Customize, machine-specific, gitignored. Do not hand-edit or commit.
- `.spacemacs.env` — generated snapshot of the shell environment, gitignored. Regenerate with `spacemacs/force-init-spacemacs-env` rather than editing; if an external tool (clangd, an LSP server) is not found from Emacs, a stale PATH here is the usual cause.
- `site-lisp/` — gitignored location for local package clones.
- `.#*` files are Emacs lockfiles: the corresponding file is open with unsaved changes in a running Emacs. Check for one before editing a file, since writing underneath an unsaved buffer leads to a conflict prompt in Emacs.

## Other directories

- `snippets/<major-mode>/` — yasnippet templates, one file per snippet, picked up automatically by the `auto-completion` layer.
- `banners/` — startup banner images; `lambda1.svg` is the active one (`dotspacemacs-startup-banner`). The `.xcf` files are the GIMP sources.
