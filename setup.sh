#!/usr/bin/env bash
NVIM_PATH="$HOME/.config/nvim"
NVIM_CACHED_PATH="$HOME/.local/share/nvim"
TMUX_PATH="$HOME/.tmux"
TMUX_CONF_PATH="$HOME/.tmux.conf"
BASHRC_PATH="$HOME/.bashrc"

STATUS_CLEAN="[Cleaned]"
STATUS_INITIALIZE="[Initialize]"
STATUS_ACTIVATE="[Activate]"

# [ Handlers ]

# 1. help
_help() {
  cat <<EOF

These packages/tools here are required for this dotfile to work perfectly
1. Neovim (https://github.com/neovim/neovim/blob/master/INSTALL.md)
2. Tmux (https://github.com/tmux/tmux/wiki/Installing)
3. NerdFont (https://github.com/ryanoasis/nerd-fonts/blob/master/readme.md#font-installation)
EOF
}

_help_init() {
  cat <<EOF
Run:
  source $BASHRC_PATH
to apply new shell setting
EOF
}

# 2. install
_install() {
  # remove old config
  if [[ -f "$BASHRC_PATH"  ]]; then
    rm "$BASHRC_PATH"
    echo "$STATUS_CLEAN .bashrc"
  fi

  if [[ -f "$TMUX_PATH"]]; then
    rm "$TMUX_PATH"
    echo "$STATUS_CLEAN .tmux.conf"
  fi
  

  # symlink config

  # bashrc
  ln -s "$(pwd)/bashrc" "$BASHRC_PATH"
  echo "$STATUS_INITIALIZE .bashrc"
  # tmux.conf
  ln -s "$(pwd)/tmux.conf" "$TMUX_PATH"
  echo "$STATUS_INITIALIZE .tmux.conf"

  # finish
  _help_init
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
  case $1 in
    -h | --help )
      _help
      exit
      ;;
    -u | --update )
      echo "update"
      exit
      ;;
    -i | --install )
      _install
      exit
      ;;
    * )
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

if [[ "$1" == '--' ]]; then
  shift
fi
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 [options]"
  echo "  -h, --help     get a help for installing required packages/tools"
  echo "  -i, --install     install needed packages and link config files/folder "
  echo "  -u, --update   update config files/folder"
  exit 1
fi
