if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

#commons
HOMEBREW_NO_AUTO_UPDATE=1
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
setopt share_history
setopt globdots
source $HOME/.fzf.zsh

. "$HOME/.cargo/env"
PS1='%2d $ '
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export DO_NOT_TRACK=1


#runn
export PATH=$PATH:/opt/homebrew/opt/libpq/bin
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh

alias runn="tmux send-keys -t 0 'yarn start:calculations' C-m \; \
  send-keys -t 1 'yarn start:node' C-m \; \
  send-keys -t 2 'yarn start:hasura' C-m \; \
  send-keys -t 3 'yarn start:rails' C-m"

alias rip="tmux list-panes -F '#P' | grep -v \"\$(tmux display-message -p '#{pane_index}')\" | xargs -I {} tmux send-keys -t {} C-c C-m"

# https://gist.github.com/colmarius/6c927994f0de197cf4ea
# git aliases (TODO: convert + move to .git)
alias s='git status -sb'

alias ga='git add -A'
alias gap='ga -p'

alias gbr='git branch -v'

gc() {
  git diff --cached | grep '\btap[ph]\b' >/dev/null &&
    echo "\e[0;31;29mOops, there's a #tapp or similar in that diff.\e[0m" ||
    git commit -v "$@"
}

alias gch='git cherry-pick'

alias gcm='git commit -v --amend'

alias gco='git checkout'

alias gd='git diff -M'
alias gd.='git diff -M --color-words="."'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'

alias gf='git fetch'

# Helper function.
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}

alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gl='glog --graph'
alias gla='gl --all'

alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'

alias gp='git push'
alias gpthis='gp origin $(git_current_branch)'
alias gpthis!='gp --set-upstream origin $(git_current_branch)'

alias grb='git rebase -p'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'

alias gr='git reset'
alias grh='git reset --hard'
alias grsh='git reset --soft HEAD~'

alias grv='git remote -v'

alias gs='git show'
alias gs.='git show --color-words="."'

alias gst='git stash'
alias gstp='git stash pop'

alias gup='git pull'

gmd() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    local selection
    selection=$(gh pr list --author "@me" --limit 50 --json headRefName,title --jq '.[] | "\(.headRefName) | \(.title)"' | \
      fzf --height 15 --prompt="Select a PR branch: " --border --exit-0 --preview="echo {}")

    if [[ -z "$selection" ]]; then
      echo "No branch selected."
      return 1
    fi

    branch=$(echo "$selection" | awk -F' | ' '{print $1}')
  fi

  echo "Merging development into PR branch: $branch ..."
  git fetch origin && git checkout "$branch" && git merge origin/development && git push origin "$branch" && git checkout -
}

export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$(brew --prefix)/opt/gnu-getopt/bin:$(brew --prefix)/opt/make/libexec/gnubin:$(brew --prefix)/opt/util-linux/bin:${PATH}"
export MACOSX_DEPLOYMENT_TARGET=10.09

# bun completions
[ -s "/Users/fishmonger45/.bun/_bun" ] && source "/Users/fishmonger45/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
