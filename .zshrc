# DEFAULT
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"
export NODENV_ROOT="$HOME/.nodenv"
export PATH="$PYENV_ROOT/bin:$RBENV_ROOT/bin:$EXENV_ROOT/bin:$NODENV_ROOT/bin:/usr/local/sbin:$PATH"

export HISTFILE="$HOME/.zshist"
export SAVEHIST=50000
export HISTSIZE=50000
export HISTCONTROL="ignorespace"

export TERM=xterm-256color

export VISUAL="vim -O"
export EDITOR="vim -O"
export GIT_EDITOR="vim -O"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export IRB_USE_AUTOCOMPLETE=false


# OPTIONS
setopt NO_BEEP

setopt share_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_no_store           # Do not save 'history' as command
setopt automenu
setopt listpacked              # Compact completion lists
setopt alwaystoend             # When complete from middle, move cursor
setopt correct                 # Spelling correction
setopt completeinword
zstyle ":completion:*" completer _expand _complete _ignored _approximate
setopt nopromptcr              # Don\'t add \n which overwrites cmds with no \n
setopt interactivecomments
setopt mark_dirs               # Adds slash to end of completed dirs


# BINDS
### Use the emacs keymap (enable ^R, ^A, ^E, etc...)
bindkey -e
bindkey "\e[3~" delete-char
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
bindkey "\e[C" forward-char
bindkey "\e[D" backward-char


# ALIASES
## General
alias "rf"="rm -rf"
alias "l"="exa"
alias "ll"="exa -la"
alias "cat"="bat --style plain"
alias "grep"="rg"
alias "rg"="rg -i"
alias "vi"="vim -O"
alias "py"="python"
alias "rb"="irb"
alias "cl"="clear && printf '\e[3J'"
function lt() {
    local LEVEL=1

    if [ $2 ];
    then
        LEVEL=$2
    fi

    exa -T -L $LEVEL $1
}
function vrg() {
    vim -O $(rg -l $1)
}

## Git
alias "gits"="git status"
alias "gita"="git add"
alias "gitc"="git commit -m"
alias "gitca"="git commit --amend"
alias "gitp"="git push"
alias "gitpl"="git pull"
alias "gitb"="git branch"
alias "gitf"="git fetch"
alias "gitch"="git checkout"
alias "gitd"="git diff"
alias "gitl"="git log"
alias "gith"="git stash"
alias "gitcl"="git clone"
alias "gitm"="git merge"
alias "gitr"="git restore --staged"
alias "gitbl"="git blame"
alias "gitcp"="git cherry-pick"
alias "gitsh"="git show"

## Configs
alias "szrc"="source ~/.zshrc"
alias "vzrc"="vi ~/.zshrc"
alias "vvrc"="vi ~/.vimrc"

## Projects
alias "fb"="cd ~/Work/flashback"
alias "pl"="cd ~/Work/peluche"

# Loads scripts from ~/.zsh
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit -D
autoload -Uz promptinit && promptinit

# PROMPT
setopt prompt_subst
autoload -U colors && colors

GIT_AHEAD="%{$fg_bold[green]%}↑%{$reset_color%}"
GIT_BEHIND="%{$fg_bold[red]%}↓%{$reset_color%}"

GIT_CLEAR="%{$fg_bold[green]%}●%{$reset_color%}"
GIT_MODIFIED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_UNTRACKED="%{$fg_bold[white]%}●%{$reset_color%}"
GIT_STAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_MERGING="%{$fg_bold[magenta]%}●%{$reset_color%}"

parse_git_branch()
{
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

parse_git_state()
{
    local GIT_STATE=$GIT_CLEAR

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD;
    then
        GIT_STATE=$GIT_MERGING
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]];
    then
        GIT_STATE=$GIT_UNTRACKED
    fi

    if ! git diff --quiet 2> /dev/null;
    then
        GIT_STATE=$GIT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null;
    then
        GIT_STATE=$GIT_STAGED
    fi

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ];
    then
        GIT_STATE=$GIT_STATE$GIT_AHEAD
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ];
    then
        GIT_STATE=$GIT_BEHIND$GIT_STATE
    fi

    if [[ -n $GIT_STATE ]];
    then
        echo "$GIT_STATE"
    fi
}

git_prompt_string()
{
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "$(parse_git_state) "
}

PS1='$(git_prompt_string)%n@%m '
RPS1='%D{%T}'


# VERSIONS MANAGEMENT
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; fi
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

zstyle ':completion:*' menu select
fpath+=~/.zfunc
