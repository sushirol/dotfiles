# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# install zplug if required
! [[ -d $HOME/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

[ -f ~/.zplug/init.zsh ] && source ~/.zplug/init.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fuzzy filtering
zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}"
zplug "bhilburn/powerlevel9k"

#Themes
if [ -z $WP ]
then
   # prezto
   zplug "modules/prompt", from:prezto
   zplug "sorin-ionescu/prezto", \
      use:"init.zsh", \
      hook-build:"ln -s $ZPLUG_HOME/repos/sorin-ionescu/prezto ~/.zprezto"
   #zplug "sorin-ionescu/prezto"
   source "$HOME/.zprezto/init.zsh"
else
   DRACULA_ARROW_ICON="❯"
   DRACULA_DISPLAY_CONTEXT=1
   zplug 'dracula/zsh', as:theme
fi

zplug "modules/history",    from:prezto
zplug "modules/utility",    from:prezto
zplug "modules/ssh",        from:prezto
zplug "modules/terminal",   from:prezto
zplug "modules/directory",  from:prezto

zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:2, on:"zsh-users/zsh-completions"

#fzf
source ~/.zplug/repos/junegunn/fzf/shell/completion.zsh

# install plugins which haven't been installed yet
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
      echo; zplug install
  else
      echo
  fi
fi

# history
setopt hist_ignore_all_dups
setopt hist_ignore_space

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

#Terminal and editor settings.
#export TERM=screen-256color
export TERM=xterm-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=vim
export P4EDITOR=vim
export P4MERGE=amergeVim

# load zplug
zplug load --verbose
set -o emacs

[ -d "/home/sushrut/arScripts/" ] && source /home/sushrut/arScripts/ar_zshrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
prompt sorin
