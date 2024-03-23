if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

setopt share_history
setopt globdots
source $HOME/.fzf.zsh
export PATH=$PATH:/opt/homebrew/opt/libpq/bin
. "$HOME/.cargo/env"
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.0
HOMEBREW_NO_AUTO_UPDATE=1
PS1='%2d $ '

