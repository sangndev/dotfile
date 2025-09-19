#!/usr/bin/env bash
CONFIG_PATH="$HOME/.config"
NVIM_PATH="$HOME/.config/nvim"
NVIM_CACHED_PATH="$HOME/.local/share/nvim"
TMUX_PATH="$HOME/.tmux"
TMUX_CONF_PATH="$HOME/.tmux.conf"
BASHRC_PATH="$HOME/.bashrc"

STATUS_CLEAN="[Cleaned]"
STATUS_INITIALIZE="[Initialize]"
STATUS_ACTIVATE="[Activate]"
STATUS_CREATE="[Create]"

# [ Handlers ]

# 1. help
_help() {
  cat <<EOF

These packages/tools here are required for this dotfile to work perfectly
1. Neovim 0.11 or above (https://github.com/neovim/neovim/blob/master/INSTALL.md)
2. Tmux (https://github.com/tmux/tmux/wiki/Installing)
3. NerdFont (https://github.com/ryanoasis/nerd-fonts/blob/master/readme.md#font-installation)
4. Fzf (https://github.com/junegunn/fzf?tab=readme-ov-file#installation)

Optional:
1. Nvm (https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
2. Lazygit (https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)
EOF
}

_help_init() {
  cat <<EOF
Run:
  source $BASHRC_PATH
to apply new shell setting
EOF
}

_install() {
  # remove old config
  if [[ -f "$BASHRC_PATH" ]]; then
    rm "$BASHRC_PATH"
    echo "$STATUS_CLEAN $BASHRC_PATH"
  fi

  if [[ -f "$TMUX_PATH" ]]; then
    rm "$TMUX_PATH"
    echo "$STATUS_CLEAN $TMUX_PATH"
  fi
  
  if [[ -f "$TMUX_CONF_PATH" ]]; then
    rm "$TMUX_CONF_PATH"
    echo "$STATUS_CLEAN $TMUX_CONF_PATH"
  fi

  if [[ -d "$NVIM_PATH"]]; then
    rm -rf "$NVIM_PATH"
    echo "$STATUS_CLEAN $NVIM_PATH"
  fi

  if [[ -d "$NVIM_CACHED_PATH"]]; then
    rm -rf "$NVIM_CACHED_PATH"
    echo "$STATUS_CLEAN $NVIM_CACHED_PATH"
  fi

  if [[ ! -d "$CONFIG_PATH" ]]; then
    mkdir "$CONFIG_PATH"
    echo "$STATUS_CREATE $CONFIG_PATH"
  fi


  # symlink config

  # bashrc
  ln -s "$(pwd)/bashrc" "$BASHRC_PATH"
  echo "$STATUS_INITIALIZE .bashrc"
  # tmux.conf
  ln -s "$(pwd)/tmux.conf" "$TMUX_CONF_PATH"
  echo "$STATUS_INITIALIZE .tmux.conf"
  # nvim
  ln -s "$(pwd)/nvim" "$NVIM_PATH"

  # finish
  _help_init
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
  case $1 in
    --help )
      _help
      exit
      ;;
    --install )
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
  echo "  --help              get a help for installing required packages/tools"
  echo "  --install           install needed packages and link config files/folder "
  exit 1
fi
