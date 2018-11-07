## DEFAULT

export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"
export EXENV_ROOT="$HOME/.exenv"

export PATH="$PYENV_ROOT/bin:$RBENV_ROOT/bin:$EXENV_ROOT/bin:/usr/local/sbin:/usr/local/opt/postgresql@9.6/bin:$PATH"
export HISTFILE="$HOME/.zshist"
export SAVEHIST=50000
export HISTSIZE=50000
export TERM=xterm-256color
export VISUAL=vim
export GIT_EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export QT_DEVICE_PIXEL_RATIO=2
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
export CLUTTER_PAINT=disable-clipped-raws:disable-culling
export CLUTTER_VBLANK=True

## OPTIONS ##
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
setopt nopromptcr              # Don't add \n which overwrites cmds with no \n
setopt interactivecomments
setopt mark_dirs               # Adds slash to end of completed dirs


## BINDS ##
# Use the emacs keymap (enable ^R, ^A, ^E, etc...)
bindkey -e
bindkey "\e[3~" delete-char
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
bindkey "\e[C" forward-char
bindkey "\e[D" backward-char


## ALIASES ##

# GENERAL
alias "rf"="rm -rf"
alias "l"="exa"
alias "ll"="exa -la"
alias "cat"="bat --style plain"
alias "hdi"="howdoi"
alias "grep"="grep --colour=always"
alias "vi"="vim -O"
alias "rec"="ffmpeg -f x11grab -r 30 -s 3840x2160 -i :0.0 -acodec pcm_s16le -codec:v libx264 -preset ultrafast -qp 0 screen.mkv"
alias "recam"="ffmpeg -f alsa -ac 2 -i pulse -f v4l2 -r 30 -s 1920x1080 -i /dev/video0 -acodec pcm_s16le -codec:v libx264 -preset ultrafast -qp 0 cam.mkv"
alias "py"="python"
alias "jlab"="jupyter lab"
alias "cl"="clear && printf '\e[3J'"
alias "aft"="android-file-transfer"
alias "ydl"="youtube-dl -x --audio-format mp3 --audio-quality 320k "

lt () {
    local LEVEL=1

    if [ $1 ];
    then
        LEVEL=$1
    fi

    exa -T -L $LEVEL
}
cag () {
    clear
    printf '\e[3J'
    cat $1 | ag -i $2
}

# GIT
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
alias "gitls"="git ls-files"
alias "gith"="git stash"
alias "gitcl"="git clone"
alias "gitm"="git merge"
alias "gitr"="git rebase"
alias "gitcp"="git cherry-pick"
alias "gitsh"="git show"

alias "irun"="ansible-playbook"

# PACMAN
alias "pi"="pikaur -S"
alias "pr"="pikaur -Rns"
alias "pu"="pikaur -Syyu"
alias "ps"="pikaur -Ss"
alias "pl"="pacman -Qen && pacman -Qem"
alias "spc"="sudo pacman -Sc && sudo pacman -Rns $(pacman -Qtdq)"

# RECAST
alias "cy"="cd ~/Work/front/cody"
alias "mn"="cd ~/Work/front/man"
alias "be"="cd ~/Work/back/bernard"
alias "rk"="cd ~/Work/back/rafiki"
alias "tm"="cd ~/Work/back/tom"
alias "pca"="cd ~/Work/core/cask"
alias "ppf"="cd ~/Work/core/prof"
alias "pat"="cd ~/Work/core/atchoum"
alias "ptm"="cd ~/Work/core/timide"
alias "psp"="cd ~/Work/core/simplet"
alias "sfr"="cd ~/Work/sfr"
alias "eg"="cd ~/Work/eggs"

# CONFIGS
alias "szrc"="source ~/.zshrc"
alias "vzrc"="vi ~/.zshrc"
alias "vvrc"="vi ~/.vimrc"

## PROMPT ##
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
RPS1=' %(?..%?)'

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
if which exenv > /dev/null; then eval "$(exenv init -)"; fi
