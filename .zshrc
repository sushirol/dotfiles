# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:$PATH:$HOME/.local/bin/:$HOME/bin:$HOME/.cargo/bin
source /opt/rust/env

export ZSH=/home/sushrut/.oh-my-zsh
export EDITOR=vim

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="true"

#DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(zsh-autosuggestions zsh-syntax-highlighting colorize git vi-mode cp wd fabric tmux fzf-git fzf)
source $ZSH/oh-my-zsh.sh

alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias ctags="ctags -R --exclude=linux-4.14 --exclude=linux-4.10.1"
alias l="exa -lahF"
alias find="fd --no-ignore"

export TERM=screen-256color

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --ignore-file $HOME/.ignore --color auto --type f'
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--bind alt-j:down,alt-k:up --height 45% --reverse --border --inline-info'
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
autoload -Uz promptinit && promptinit
prompt elite
function parse_git_dirty {
    #[[ $(git status -uno 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
    [[ $(git status -suno | tail -n1) ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
function parse_current_dir {
    ruby -e "puts ('../'+Dir.getwd.split('/').last(2).join('/')).gsub('//', '/')"
}

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown
# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment 246 235 "%(!.%{%F{yellow}%}.)$USER@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 172 black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    #vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
	# if files are not added
	prompt_segment red white
	st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
	# if any modification
	prompt_segment yellow black
	st='±'
      else
	# if working copy is clean
	prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
	prompt_segment red black
	st='±'
      elif `hg st | grep -q "^[MA]"`; then
	prompt_segment yellow green
	st='±'
      else
	prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

_collapsed_wd() {
  echo -n $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

# Dir: current working directory
prompt_dir() {
  prompt_segment 239 248 $(_collapsed_wd )
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  #[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

 build_prompt() {
	RETVAL=$?
	prompt_status
	prompt_virtualenv
	prompt_context
	prompt_dir
	prompt_git
	prompt_hg
	prompt_end
}



#
setopt prompt_subst # enable command substition in prompt

PROMPT='' # no initial prompt, set dynamically

ASYNC_PROC=0
function precmd() {
    function async() {
        # save to temp file
        printf "%s" "$(build_prompt)" > "/tmp/zsh_prompt_$$"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    PROMPT="$(cat /tmp/zsh_prompt_$$)"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

alias glg="git log --pretty=oneline --abbrev-commit | fzf --preview 'echo {} | cut -f 1 -d \" \" | xargs git show --color=always'"

# GIT heart FZF
# -------------

is_in_git_repo() {
	git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
fzf --height 50% "$@" --border
}

function gf() {
	is_in_git_repo || return
	git -c color.status=always status --short |
		fzf-down -m --ansi --nth 2..,.. \
		--preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
		cut -c4- | sed 's/.* -> //'
}

function gb() {
	is_in_git_repo || return
	git branch -a --color=always | grep -v '/HEAD\s' | sort |
		fzf-down --ansi --multi --tac --preview-window right:70% \
		--preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
		sed 's/^..//' | cut -d' ' -f1 |
		sed 's#^remotes/##'
}

function gt() {
	is_in_git_repo || return
	git tag --sort -version:refname |
		fzf-down --multi --preview-window right:70% \
		--preview 'git show --color=always {} | head -'$LINES
}

function gh() {
	is_in_git_repo || return
	git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
		fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
		--header 'Press CTRL-S to toggle sort' \
		--preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
		grep -o "[a-f0-9]\{7,\}"
}

function gr() {
	is_in_git_repo || return
	git remote -v | awk '{print $1 "\t" $2}' | uniq |
		fzf-down --tac \
		--preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' | cut -d$'\t' -f1
}

function gs() {
	is_in_git_repo || return
	git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
		cut -d: -f1
}

#----
#tmux
#----

function fts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

function ftl {
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
  tad "$session"
}
