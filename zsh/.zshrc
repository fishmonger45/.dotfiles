if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi


setopt share_history
export PATH=$PATH:/opt/homebrew/opt/libpq/bin
source $HOME/.fzf.zsh
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
. "$HOME/.cargo/env"
HOMEBREW_NO_AUTO_UPDATE=1
