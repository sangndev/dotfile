#!/usr/bin/env bash
NVIM_PATH="$HOME/.config/nvim"
TMUX_PATH="$HOME/.tmux"
TMUX_CONF_PATH="$HOME/.tmux.conf"

# cleanup() {
#   if [[ -d "$NVIM_PATH" ]]; then
#     echo "has nvim folder\n"
#   fi
#   if [[ -d "$TMUX_PATH" ]]; then
#     echo "has tmux folder\n"
#   fi
#   if [[ -f "$TMUX_CONF_PATH" ]]; then
#     echo "has tmux config file\n"
#   fi
# }

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do 
  case $1 in
    -c | --clean )
      echo "cleanup"
      exit
      ;;
    -s | --string )
      shift
      string=$1
      ;;
    -f | --flag )
      flag=1
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
  echo "  -c, --clean     cleanup"
  echo "  -s, --string X  pass string"
  echo "  -f, --flag      enable flag"
  exit 1
fi
