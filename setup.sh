#!/usr/bin/env bash
NVIM_PATH="$HOME/.config/nvim"
NVIM_CACHED_PATH="$HOME/.local/share/nvim"
TMUX_PATH="$HOME/.tmux"
TMUX_CONF_PATH="$HOME/.tmux.conf"
BASHRC_PATH="$HOME/.bashrc"

# [ Handlers ]
help() {
  cat <<EOF
\n
These packages/tools here are needed for this dotfile to work perfectly\n\n
1. Neovim (https://github.com/neovim/neovim/blob/master/INSTALL.md)\n
2. Tmux (https://github.com/tmux/tmux/wiki/Installing)\n
3. NerdFont (https://github.com/ryanoasis/nerd-fonts/blob/master/readme.md#font-installation)
EOF
}

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
  case $1 in
    -h | --help )
      echo $(help)
      exit
      ;;
    -c | --clean )
      echo $(clean)
      exit
      ;;
    -u | --update )
      echo "update"
      exit
      ;;
    -i | --install )
      echo "install"
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
  echo "  -i, --init     install needed packages and link config files/folder "
  echo "  -u, --update   update config files/folder"
  echo "  -c, --clean    delete all config files/folder"
  exit 1
fi
