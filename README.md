# Spacemacs configuration

Personal [Spacemacs](https://github.com/syl20bnr/spacemacs/) user configuration (`~/.spacemacs.d`).

It started from the [Practicalli Spacemacs configuration](https://github.com/practicalli/spacemacs-config) by John Stevenson, which is built around Clojure development, and has since been extended for C/C++, CUDA, Go, Java, PHP and Python.

## What is configured

- **Editing**: Vim style, `doom-gruvbox` theme, doom mode-line, Fira Code with ligatures in programming modes
- **Languages**: Clojure (CIDER + LSP), C/C++ (clangd), CUDA (`cuda-mode`), Go, Java, PHP, Python, JavaScript, HTML, YAML, JSON, Markdown, Emacs Lisp
- **LSP**: quiet by default (no doc popups, no sideline); both are switched on again in C/C++ buffers only
- **Tools**: Magit with Forge, DAP debugging, Docker, Treemacs, Ranger, vterm, tree-sitter highlighting, org-journal
- **Snippets**: yasnippet templates for Clojure, ClojureScript, Markdown, Org and shell in `snippets/`

## Requirements

- Emacs 28.2 or newer
- Spacemacs on the `develop` branch in `~/.emacs.d`
- [Fira Code](https://github.com/tonsky/FiraCode) font
- `ripgrep` for project search
- `clangd` at `/usr/bin/clangd` for C/C++
- `cmake`, `libtool-bin` and `libvterm-dev` to build the vterm module
- `aspell` with the dictionaries you need (e.g. `aspell-de`) for spell checking
- The language servers for the other languages you use; lsp-mode offers to install most of them on first use

For CUDA development, the CUDA toolkit (`nvcc`, `cuda-gdb`) must be on the `PATH` that Emacs sees.

## Installation

```bash
git clone https://github.com/MehmetGoekce/spacemacs-config.git ~/.spacemacs.d
```

Remove an existing `~/.spacemacs` file, as it takes precedence over `~/.spacemacs.d/init.el`. Start Emacs; Spacemacs installs all packages on first launch.

## Layout

`init.el` is the main Spacemacs configuration file: layers and their variables, Spacemacs settings, and additional packages.

`dotspacemacs/user-config` contains no configuration itself. It loads these files, in order:

| File | Content |
|---|---|
| `user-config.el` | General tweaks, Clerk notebook command, lsp-ui in C/C++ buffers |
| `clojure-config.el` | clojure-mode options, Portal data inspector commands, custom Clojure functions |
| `theme-config.el` | Custom doom mode-line |
| `version-control-config.el` | Magit and Forge |

Present but not loaded (their `load` calls in `init.el` are commented out):

- `org-config.el` — TODO workflow and faces for Org
- `eshell-config.el` — custom eshell prompt
- `deprecated-config.el` — archive of retired configuration

To add your own configuration, create a `<topic>-config.el` file and add a `load` for it in `dotspacemacs/user-config`.

### Files that are not tracked

- `emacs-custom-settings.el` — written by Emacs Customize, loaded if present
- `.spacemacs.env` — environment variables captured by Spacemacs; regenerate with `SPC SPC spacemacs/force-init-spacemacs-env` after changing your shell `PATH`
- `site-lisp/` — local package clones

## CUDA

`.cu` and `.cuh` files open in `cuda-mode`, which derives from `c++-mode`, so clangd and the C/C++ LSP settings apply. The `,` major-mode key bindings of the C/C++ layer are not available there; use the global commands instead:

| Key | Action |
|---|---|
| `SPC c c` | Compile, e.g. `nvcc -O3 file.cu -o prog` |
| `SPC c r` | Recompile |
| `SPC SPC gdb` | Debug, with `cuda-gdb -i=mi ./prog` (build with `-g -G`) |

clangd needs a `compile_commands.json` in the project, and usually a `.clangd` file that removes the `nvcc`-only flags.

## Credits and license

Based on [practicalli/spacemacs-config](https://github.com/practicalli/spacemacs-config). The [Practicalli Spacemacs book](https://practical.li/spacemacs) explains the Clojure workflow this configuration was designed for.

Licensed under [Creative Commons Attribution-ShareAlike 4.0 International](LICENSE), the same license as the original.
