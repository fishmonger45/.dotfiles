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
chruby ruby-3.3.1
HOMEBREW_NO_AUTO_UPDATE=1
PS1='%2d $ '

# deno
export DENO_INSTALL="/Users/fishmonger45/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export PTPIMG_KEY=6be13ebf-2c18-48d3-ab3b-7851138f74f4
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
