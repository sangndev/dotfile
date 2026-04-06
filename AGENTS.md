# Repository Guidelines

## Project Structure & Module Organization

This repository is a personal dotfiles collection. Key paths:

- `bashrc`: Bash prompt, aliases, and environment variables.
- `tmux.conf`: tmux settings and key bindings.
- `nvim/`: Neovim configuration (`init.lua`, `lua/`, `lsp/`, `snippets/`, `lazy-lock.json`).
- `vim/vimrc`: Vim config (with plugins via vim-plug); `vim/.netrwhist` is local state.
- `ghostty/`: Ghostty terminal config and themes.
- `termux/`: Termux colors and font assets.
- `setup.sh`: installer that symlinks configs into your home directory.

## Build, Test, and Development Commands

There is no “build” step. Primary workflow is install + smoke-check:

- `./setup.sh help`: shows available actions and prerequisites.
- `./setup.sh install`: links configs into `$HOME` (defaults to all). Interactive component picker in a TTY; use `--only nvim,tmux` for non-interactive use. Prompts before overwriting; existing targets are backed up under `~/.dotfile-backup/<timestamp>/`.
- `./setup.sh clean`: removes previously linked targets (defaults to all). By default it only removes symlinks pointing back into this repo (use `--force` to remove non-managed targets).
- `./setup.sh upgrade`: pulls the latest dotfiles via `git pull --rebase`.
- `sh -n setup.sh`: basic shell syntax check (script is POSIX `sh` compatible; `sh setup.sh ...` also works).
- `nvim` / `tmux`: manual smoke tests after changing editor/terminal configs.

## Coding Style & Naming Conventions

- Follow the existing file style; avoid drive-by reformatting.
- Vim defaults imply 2-space indent with `expandtab` (`vim/vimrc`).
- Neovim formatting is driven by editor tooling (e.g., `stylua` for Lua and `prettier/prettierd` for JS/TS) via the Neovim config; prefer running formatters through Neovim rather than ad-hoc scripts.
- Keep filenames and directories descriptive and config-scoped (e.g., `nvim/lsp/<tool>.lua`).

## Testing Guidelines

No automated test suite is configured. Prefer small, reviewable changes and verify by:

- launching `nvim` and checking startup errors
- exercising the relevant mappings/plugins
- validating tmux reload behavior (`tmux source-file ~/.tmux.conf` if applicable)

## Commit & Pull Request Guidelines

Git history uses short, imperative messages like `update neovim config` and occasional `fix ...`.

- Commits: one logical change per commit; use lowercase, action-first subjects.
- PRs: include what changed, why, and any manual verification notes (OS, terminal, Neovim version). If you intentionally change Neovim plugins, mention `nvim/lazy-lock.json` updates explicitly.
