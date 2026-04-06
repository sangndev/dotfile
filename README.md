# Sang's dotfile

A collection for my dev environment settings

## Setup

`setup.sh` is a small helper to link configs into your `$HOME`. Running it with no args prints help:

- `./setup.sh` (or `sh setup.sh`)

### Install

Pick what to link (required):

- `./setup.sh install --only nvim,tmux`
- `./setup.sh install --all`

The installer prompts before overwriting and backs up replaced targets under `~/.dotfile-backup/<timestamp>/`.

### Clean

Remove previously linked targets (required selection):

- `./setup.sh clean --only nvim --with-cache`
- `./setup.sh clean --all`

By default, `clean` only removes symlinks that point back into this repo. Use `--force` to remove non-managed targets.

### Upgrade

Pull the latest changes:

- `./setup.sh upgrade`
