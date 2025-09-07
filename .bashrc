export BASH_SILENCE_DEPRECATION_WARNING=1
# promp UI
PROMPT_COMMAND='
  PS1_CMD1=$(git branch --show-current 2>/dev/null)
  if [ -n "$PS1_CMD1" ]; then
    PS1_BRANCH=" \[\e[32m\](${PS1_CMD1})\[\e[0m\]"
  else
    PS1_BRANCH=""
  fi

  # If at home, show ~
  if [ "$PWD" = "$HOME" ]; then
    SHORT_DIR="~"
  else
    IFS="/" read -ra DIR_PARTS <<< "${PWD#$HOME/}"  # Remove home prefix
    DIR_COUNT=${#DIR_PARTS[@]}
    if (( DIR_COUNT > 3 )); then
      SHORT_DIR=".../${DIR_PARTS[DIR_COUNT-3]}/${DIR_PARTS[DIR_COUNT-2]}/${DIR_PARTS[DIR_COUNT-1]}"
    else
      SHORT_DIR="${PWD/#$HOME/~}"  # Replace full home path with ~
    fi
  fi

  PS1="\[\e[34m\]$SHORT_DIR\[\e[0m\]${PS1_BRANCH}\n\[\e[35m\]\$\[\e[0m\] "
'

# brew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# alias
alias lsa='ls -A'
alias l='ls -l'
alias ll='ls -la'
