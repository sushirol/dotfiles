# install zplug if required
! [[ -d $HOME/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

[ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# prezto
zplug "modules/prompt", from:prezto
#zplug "modules/completion", from:prezto #currently broken

#Themes
source "$HOME/.zprezto/init.zsh"

# fuzzy filtering
zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"

# install plugins which haven't been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  else
      echo
  fi
fi

#fzf
source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

# history

setopt hist_ignore_all_dups
setopt hist_ignore_space

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

export TERM=xterm-256color
export EDITOR=vim
export P4EDITOR=vim
export P4MERGE=amergeVim

# load zplug
zplug load --verbose
