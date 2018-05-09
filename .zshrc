# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/.local/bin/
source /opt/rust/env

# Path to your oh-my-zsh installation.
export ZSH=/home/sushrut/.oh-my-zsh
export EDITOR=vim

LC_CTYPE=en_US.UTF-8
#LC_ALL=en_US.UTF-8
#export FZF_DEFAULT_COMMAND='ag -g ""'
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore linux-4.10.1 -g ""'
#export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
#export FZF_DEFAULT_COMMAND='rg --files --glob ""'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="powerlevel9k/powerlevel9k"

#pure prompt
#autoload -U promptinit; promptinit
#ZSH_THEME=""
#PURE_CMD_MAX_EXEC_TIME=10
#prompt pure

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

 alias backup='svn diff -x "-w --ignore-eol-style"  > ~/backup/async-$(date -d "today" +"%Y-%m-%d-%H%M").diff'

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting colorize git vi-mode cp wd fabric)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export TERM=screen-256color

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --ignore-file $HOME/.ignore --color auto --type f'
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--height 45% --reverse --border --inline-info'
#export FZF_COMPLETION_TRIGGER=''
export FZF_COMPLETION_TRIGGER='**'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


bindkey '^T' fzf-completion

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_complete_git() {
    ARGS="$@"
    local branches
    branches=$(git branch -vv --all)
    if [[ $ARGS == 'git branch'* ]] || [[ $ARGS == 'git checkout'* ]]; then
        _fzf_complete "--reverse --multi" "$@" < <(
            echo $branches
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}

_fzf_complete_wd() {
    ARGS="$@"
    local warp_points
    warp_points=$(wd list | rg -v "warp points")
	_fzf_complete "--reverse --multi" "$@" < <(echo $warp_points)
}

_fzf_complete_wd_post() {
  awk '{print $1}'
}

_fzf_complete_yadm() {
    ARGS="$@"
    local dotfiles
	case $ARGS in
		'yadm add'*)
			dotfiles=$(yadm status | grep -w "modified:")
			_fzf_complete "--reverse --multi" "$@" < <(echo $dotfiles)
			;;
		'yadm diff'*)
			dotfiles=$(yadm status | grep -w "modified:")
			_fzf_complete "--reverse --multi" "$@" < <(echo $dotfiles)
			;;
	esac

}

_fzf_complete_yadm_post() {
  awk '{print $2}'
}

# ========
# PROMPT
# ========
#
#autoload -Uz promptinit && promptinit
#prompt elite
#function parse_git_dirty {
    #[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
#}
#function parse_git_branch {
    #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
#}
#function parse_current_dir {
    #ruby -e "puts ('../'+Dir.getwd.split('/').last(2).join('/')).gsub('//', '/')"
#}

#CURRENT_BG='NONE'
#SEGMENT_SEPARATOR=''

## Begin a segment
## Takes two arguments, background and foreground. Both can be omitted,
## rendering default background/foreground.
#prompt_segment() {
  #local bg fg
  #[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  #[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  #if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    #echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  #else
    #echo -n "%{$bg%}%{$fg%} "
  #fi
  #CURRENT_BG=$1
  #[[ -n $3 ]] && echo -n $3
#}

## End the prompt, closing any open segments
#prompt_end() {
  #if [[ -n $CURRENT_BG ]]; then
    #echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  #else
    #echo -n "%{%k%}"
  #fi
  #echo -n "%{%f%}"
  #CURRENT_BG=''
#}

## Prompt components
## Each component will draw itself, and hide itself if no information needs to be shown
## Context: user@hostname (who am I and where am I)
#prompt_context() {
  #if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    #prompt_segment 246 235 "%(!.%{%F{yellow}%}.)$USER@%m"
  #fi
#}

## Git: branch/detached head, dirty status
#prompt_git() {
  #local ref dirty mode repo_path
  #repo_path=$(git rev-parse --git-dir 2>/dev/null)

  #if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    #dirty=$(parse_git_dirty)
    #ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    #if [[ -n $dirty ]]; then
      #prompt_segment 172 black
    #else
      #prompt_segment green black
    #fi

    #if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      #mode=" <B>"
    #elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      #mode=" >M<"
    #elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      #mode=" >R>"
    #fi

    #setopt promptsubst
    #autoload -Uz vcs_info

    #zstyle ':vcs_info:*' enable git
    #zstyle ':vcs_info:*' get-revision true
    #zstyle ':vcs_info:*' check-for-changes true
    #zstyle ':vcs_info:*' stagedstr '✚'
    #zstyle ':vcs_info:git:*' unstagedstr '●'
    #zstyle ':vcs_info:*' formats ' %u%c'
    #zstyle ':vcs_info:*' actionformats ' %u%c'
    #vcs_info
    #echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
  #fi
#}

#prompt_hg() {
  #local rev status
  #if $(hg id >/dev/null 2>&1); then
    #if $(hg prompt >/dev/null 2>&1); then
      #if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        ## if files are not added
        #prompt_segment red white
        #st='±'
      #elif [[ -n $(hg prompt "{status|modified}") ]]; then
        ## if any modification
        #prompt_segment yellow black
        #st='±'
      #else
        ## if working copy is clean
        #prompt_segment green black
      #fi
      #echo -n $(hg prompt "☿ {rev}@{branch}") $st
    #else
      #st=""
      #rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      #branch=$(hg id -b 2>/dev/null)
      #if `hg st | grep -q "^\?"`; then
        #prompt_segment red black
        #st='±'
      #elif `hg st | grep -q "^[MA]"`; then
        #prompt_segment yellow green
        #st='±'
      #else
        #prompt_segment green black
      #fi
      #echo -n "☿ $rev@$branch" $st
    #fi
  #fi
#}

## Dir: current working directory
#prompt_dir() {
  #prompt_segment 239 248 '%~'
#}

## Virtualenv: current working virtualenv
#prompt_virtualenv() {
  #local virtualenv_path="$VIRTUAL_ENV"
  #if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    #prompt_segment blue black "(`basename $virtualenv_path`)"
  #fi
#}

## Status:
## - was there an error
## - am I root
## - are there background jobs?
#prompt_status() {
  #local symbols
  #symbols=()
  #[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  #[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  #[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  #[[ -n "$symbols" ]] && prompt_segment black default "$symbols"
#}

#build_prompt() {
	#RETVAL=$?
	#prompt_status
	#prompt_virtualenv
	#prompt_context
	#prompt_dir
	#prompt_git
	#prompt_hg
	#prompt_end
#}

#PROMPT='%{%f%b%k%}$(build_prompt) '
