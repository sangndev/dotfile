#!/bin/sh
set -eu
if (set -o pipefail) 2>/dev/null; then
  set -o pipefail
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

DEFAULT_COMPONENTS="bashrc tmux nvim vim ghostty termux"

YES=0
FORCE=0
DRY_RUN=0
WITH_CACHE=0
ONLY_COMPONENTS=""
ALL=0

log() { printf '%s\n' "$*"; }
info() { printf '%s\n' "info: $*"; }
ok() { printf '%s\n' "ok: $*"; }
warn() { printf '%s\n' "warn: $*" >&2; }
die() { printf '%s\n' "error: $*" >&2; exit 1; }

prompt_confirm() {
  prompt="$1"
  if [ "$YES" -eq 1 ]; then
    return 0
  fi
  printf '%s' "${prompt} [y/N] "
  read reply || reply=""
  case "$reply" in
    y|Y|yes|YES|Yes) return 0 ;;
    *) return 1 ;;
  esac
}

usage() {
  cat <<'EOF'
Repository dotfiles installer.

Usage:
  ./setup.sh [action] [options]

Actions:
  help      Show commands and prerequisites
  install   Link selected configs into $HOME (requires --only/--all)
  clean     Remove previously linked configs (requires --only/--all)
  upgrade   Pull latest changes from git remote

Options:
  --only <csv>     Components (e.g. "nvim,tmux")
  --all            Select all components (install/clean)
  -y, --yes        Assume "yes" for prompts
  --force          Also touch non-managed targets (dangerous)
  --dry-run        Print actions without changing anything
  --with-cache     (clean) also remove Neovim cache (~/.local/share/nvim)

Components:
  bashrc, tmux, nvim, vim, ghostty, termux

Examples:
  ./setup.sh
  ./setup.sh install --only nvim,tmux
  ./setup.sh install --all
  ./setup.sh clean --only nvim --with-cache
  ./setup.sh clean --all
  ./setup.sh upgrade
EOF
}

prereqs() {
  cat <<'EOF'
Recommended tools:
  - Neovim 0.11+  (https://github.com/neovim/neovim/blob/master/INSTALL.md)
  - tmux          (https://github.com/tmux/tmux/wiki/Installing)
  - Nerd Font     (https://github.com/ryanoasis/nerd-fonts)
  - fzf           (https://github.com/junegunn/fzf)

Optional:
  - nvm           (https://github.com/nvm-sh/nvm)
  - lazygit       (https://github.com/jesseduffield/lazygit)
EOF
}

normalize_csv() {
  printf '%s' "${1:-}" | tr -d ' ' | tr '[:upper:]' '[:lower:]'
}

component_source() {
  case "$1" in
    bashrc) printf '%s' "$REPO_ROOT/bashrc" ;;
    tmux) printf '%s' "$REPO_ROOT/tmux.conf" ;;
    nvim) printf '%s' "$REPO_ROOT/nvim" ;;
    vim) printf '%s' "$REPO_ROOT/vim/vimrc" ;;
    ghostty) printf '%s' "$REPO_ROOT/ghostty" ;;
    termux) printf '%s' "$REPO_ROOT/termux" ;;
    *) return 1 ;;
  esac
}

component_target() {
  case "$1" in
    bashrc) printf '%s' "$HOME/.bashrc" ;;
    tmux) printf '%s' "$HOME/.tmux.conf" ;;
    nvim) printf '%s' "$HOME/.config/nvim" ;;
    vim) printf '%s' "$HOME/.vimrc" ;;
    ghostty) printf '%s' "$HOME/.config/ghostty" ;;
    termux) printf '%s' "$HOME/.termux" ;;
    *) return 1 ;;
  esac
}

abs_link_target() {
  link="$1"
  link_dir="$2"
  case "$link" in
    /*) printf '%s' "$link" ;;
    *)
      (
        cd "$link_dir" 2>/dev/null || exit 1
        cd "$(dirname "$link")" 2>/dev/null || exit 1
        printf '%s/%s' "$(pwd)" "$(basename "$link")"
      )
      ;;
  esac
}

is_managed_symlink() {
  target="$1"
  [ -L "$target" ] || return 1
  link="$(readlink "$target" 2>/dev/null || true)"
  [ -n "$link" ] || return 1
  abs="$(abs_link_target "$link" "$(dirname "$target")" 2>/dev/null || true)"
  case "$abs" in
    "$REPO_ROOT"/*) return 0 ;;
    *) return 1 ;;
  esac
}

already_linked() {
  target="$1"
  source="$2"
  [ -L "$target" ] || return 1
  link="$(readlink "$target" 2>/dev/null || true)"
  [ -n "$link" ] || return 1
  abs="$(abs_link_target "$link" "$(dirname "$target")" 2>/dev/null || true)"
  [ "$abs" = "$source" ]
}

ensure_parent_dir() {
  dest="$1"
  parent="$(dirname "$dest")"
  if [ ! -d "$parent" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      info "[dry-run] mkdir -p $parent"
    else
      mkdir -p "$parent"
    fi
  fi
}

backup_and_remove() {
  target="$1"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    return 0
  fi

  ts="$(date +%Y%m%d-%H%M%S)"
  backup_root="$HOME/.dotfile-backup/$ts"

  case "$target" in
    "$HOME"/*)
      rel="${target#"$HOME"/}"
      backup_path="$backup_root/$rel"
      ;;
    *)
      rel="$(printf '%s' "$target" | sed 's|/|_|g')"
      backup_path="$backup_root/$rel"
      ;;
  esac

  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] backup $target -> $backup_path"
    info "[dry-run] rm -rf $target"
    return 0
  fi

  mkdir -p "$(dirname "$backup_path")"
  mv "$target" "$backup_path"
}

link_component() {
  component="$1"
  source="$(component_source "$component" 2>/dev/null)" || die "Unknown component: $component"
  target="$(component_target "$component" 2>/dev/null)" || die "Unknown component: $component"
  [ -e "$source" ] || die "Missing source for $component: $source"

  if already_linked "$target" "$source"; then
    info "[skip] $component already linked ($target)"
    return 0
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$FORCE" -ne 1 ] && ! is_managed_symlink "$target"; then
      if ! prompt_confirm "Overwrite non-managed target $target?"; then
        warn "Skipping $component ($target)"
        return 0
      fi
    else
      if ! prompt_confirm "Replace existing $target?"; then
        warn "Skipping $component ($target)"
        return 0
      fi
    fi
    backup_and_remove "$target"
  fi

  ensure_parent_dir "$target"
  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] ln -s $source $target"
  else
    ln -s "$source" "$target"
    ok "[link] $component -> $target"
  fi
}

clean_component() {
  component="$1"
  target="$(component_target "$component" 2>/dev/null)" || die "Unknown component: $component"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    info "[skip] $component missing ($target)"
    return 0
  fi

  if [ "$FORCE" -ne 1 ] && ! is_managed_symlink "$target"; then
    warn "Skipping non-managed target: $target (use --force to remove)"
    return 0
  fi

  if ! prompt_confirm "Remove $target?"; then
    warn "Skipping $component ($target)"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] rm -rf $target"
  else
    rm -rf "$target"
    ok "[clean] $component ($target)"
  fi
}

select_components() {
  if [ "$ALL" -eq 1 ]; then
    printf '%s' "$DEFAULT_COMPONENTS"
    return 0
  fi
  if [ -n "$ONLY_COMPONENTS" ]; then
    printf '%s' "$ONLY_COMPONENTS"
    return 0
  fi
  printf '%s' ""
}

run_install() {
  components="$(select_components)"
  if [ -z "$components" ]; then
    usage
    die "install requires --only <csv> or --all"
  fi
  for component in $components; do
    link_component "$component"
  done

  log ""
  info "Next: source \$HOME/.bashrc"
}

run_clean() {
  components="$(select_components)"
  if [ -z "$components" ]; then
    usage
    die "clean requires --only <csv> or --all"
  fi
  for component in $components; do
    clean_component "$component"
  done

  if [ "$WITH_CACHE" -eq 1 ]; then
    cache="$HOME/.local/share/nvim"
    if [ -d "$cache" ]; then
      if prompt_confirm "Remove Neovim cache ($cache)?"; then
        if [ "$DRY_RUN" -eq 1 ]; then
          info "[dry-run] rm -rf $cache"
        else
          rm -rf "$cache"
          ok "[clean] nvim cache ($cache)"
        fi
      fi
    fi
  fi
}

run_upgrade() {
  command -v git >/dev/null 2>&1 || die "git is required for upgrade"
  [ -d "$REPO_ROOT/.git" ] || die "Not a git repository: $REPO_ROOT"

  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] git -C $REPO_ROOT pull --rebase --autostash"
    return 0
  fi

  git -C "$REPO_ROOT" pull --rebase --autostash
}

main() {
  action="${1:-}"
  if [ -n "$action" ]; then
    shift
  fi

  # Default behavior: show help (even when run as `sh setup.sh` or `./setup.sh`,
  # including when stdin is piped).
  if [ -z "$action" ]; then
    action="help"
  fi

  while [ "${#:-0}" -gt 0 ]; do
    case "$1" in
      -y|--yes) YES=1 ;;
      --force) FORCE=1 ;;
      --dry-run) DRY_RUN=1 ;;
      --with-cache) WITH_CACHE=1 ;;
      --all) ALL=1 ;;
      --only)
        shift || die "--only requires a value"
        ONLY_COMPONENTS="$(normalize_csv "${1:-}" | tr ',' ' ')"
        ;;
      -h|--help)
        action="help"
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
    shift || true
  done

  case "${action:-}" in
    help)
      usage
      log ""
      prereqs
      ;;
    install)
      if [ "$DRY_RUN" -eq 1 ]; then info "dry-run enabled (no changes will be made)"; fi
      run_install
      ;;
    clean)
      if [ "$DRY_RUN" -eq 1 ]; then info "dry-run enabled (no changes will be made)"; fi
      run_clean
      ;;
    upgrade)
      if [ "$DRY_RUN" -eq 1 ]; then info "dry-run enabled (no changes will be made)"; fi
      run_upgrade
      ;;
    *)
      usage
      die "Unknown action: $action"
      ;;
  esac
}

main "$@"
