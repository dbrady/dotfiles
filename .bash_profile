#!/bin/sh

# Figure out operating system & machine
OS_NAME=$(uname -s)

IS_OSX=false
IS_LINUX=false
IS_WINDOWS=false # tbd, may prefer IS_DOCKER or IS_WSL etc

case "$OS_NAME" in
    Darwin)
        IS_OSX=true
        ;;
    Linux)
        IS_LINUX=true
        ;;
    CYGWIN*|MINGW*|MSYS*)
        # YAGNI? Do I ever hit this on WSL or Docker under windows?
        IS_WINDOWS=true
        ;;
    *)
        echo -e "\033[1;37;41mCannot identify your operating system: '$OS_NAME'\033[0m"
        ;;
esac

HOSTNAME=$(hostname)

export EDITOR=$(echo `which emacs` -nw -q -l ~/.emacstiny)
export GEMEDITOR=$(echo `which emacs` -nw)
export CVSEDITOR=$(echo `which emacs` -nw -q -l ~/.emacstiny)
export SVN_EDITOR=$(echo `which emacs` -nw -q -l ~/.emacstiny)

case "$OS_NAME" in
    Linux)
        # export JAVA_HOME='/usr/lib/jvm/default-java'
        export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64/'
        ;;
    Darwin)
        # export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'
        ;;
    *)
        echo '~/.bash_profile has no clue what OS this is; not setting JAVA_HOME.'
        ;;
esac

# === OSX Specific ======================================================
# Search the ls manpage for "CLICOLOR" and "color designators for an
# explanation of this goodness.

# CLICOLOR: Search "man ls" for "CLICOLOR" and "color designators".
# a: black                                        1.  directory
# b: red                                          2.  symbolic link
# c: green                                        3.  socket
# d: brown                                        4.  pipe
# e: blue                                         5.  executable
# f: magenta                                      6.  block special
# g: cyan                                         7.  character special
# h: light grey                                   8.  executable with setuid bit set
# A: bold black, usually shows up as dark grey    9.  executable with setgid bit set
# B: bold red                                     10. directory writable to others, with sticky bit
# C: bold green                                   11. directory writable to others, without sticky bit
# D: bold brown, usually shows up as yellow
# E: bold blue
# F: bold magenta
# G: bold cyan
# H: bold light grey; looks like bright white
# x: default foreground or background
#
# The standard Mac OSX colors are: exfxcxdxbxegedabagacad
#
# TODO: export these to functions or scripts called light_bg or dark_bg, etc.
export CLICOLOR=1
# Standard colors look good on a white background
# export LSCOLORS=exfxcxdxbxegedabagacad
# export LS_COLORS=exfxcxdxbxegedabagacad

# Swap blue/cyan for better visibility on dark bg
#export LSCOLORS=gxfxcxdxbxegedabagacad
# === OSX Specific ======================================================

# Use less by default b/c search works better. But keep most inifile
# here for tweaking.
#export PAGER="most"
export MOST_INIFILE='/etc/most.rc'

GREP_OPTIONS='--color=auto'
GREP_COLOR='1;32'

# ----------------------------------------------------------------------
# Terminal colours (after installing GNU coreutils)
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;37m\]" #change this for letter colors
HII="\[\033[0;31m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

export HISTFILESIZE=10000

if [[ $PATH != *"private_bin"* ]]; then
    export PATH=~/private_bin:$PATH
fi

# Acima-specific stuffs - if more than this path needs to be here, please make a
# .acima file and source_files() it
if [[ $PATH != *"acima/bin"* ]]; then
    export PATH=~/acima/bin:$PATH
fi

source_files()
{
  local file

  for file in "$@" ; do
    # echo -e "\033[32msource_files(): sourcing $file\033[0m"
    file=${file/\~\//$HOME\/} # Expand ~/

    if [[ -s "${file}" ]] ; then
      source "${file}"
    # else
    #     # I found this useful for debugging, now it's just noisy
    #   if [[ ! -e "${file}" ]] ; then
    #     printf "NOTICE: ${file} does not exist, not loading.\n"
    #   else
    #     true # simply an empty file, no warning necessary.
    #   fi
    fi
  done

  return 0
}

source_files ~/.aliases \
  ~/.bash_completions \
  ~/.git-completion.bash \
  ~/.nav \
  ~/.private \
  ~/.ps1_functions \
  ~/.bash_functions \
  ~/.current-project \
  ~/.hue.conf \
  ~/.platform-dev \
  ~/.aws-hack

# Turn on path completion for my go command.
# This must come after git-completion.bash.
complete -o default -o nospace -F _git_checkout go

# PS1 EMOJIS

case "$HOSTNAME" in
    Simples-MacBook-Pro.local)
        ps1_set --prompt "💳"
        export PS2=💳💳
        ;;
    thinky)
        ps1_set --prompt "🧠"
        export PS2=🧠💭
        ;;
    *)
        ps1_set --prompt '$'
        export PS2='$$'
        echo -e "\033[1;37;41mNEW MACHINE: It's \D{%H} O'Clock! Check .bash_profile and/or .ps1_functions. Do you have my dotfiles repo?\033[0m"
        ;;
esac

# 2022-07-25: Hoping this works...
if [ $IS_OSX ]; then
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    rvm default 3.3.6
fi

if [ $IS_LINUX ]; then
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

# Acima
if [ "$HOSTNAME" == "Simples-MacBook-Pro.local" ]; then
    # MP tests need this every time, so
    export TZ='America/Denver'

    # This adds 80 seconds to the MP spec suite. It is good to pass in when we
    # need the whole suite to interop correctly, but when trying to TDD it is
    # agonizing.
    # export SPEC_SEED=true

    # Acima AWS
    export AWS_PROFILE=AcimaNonprod-NonProdDeveloperAccess
    # export KUBECONFIG=~/.kube/nonprod/preflight
    # export KUBECONFIG=~/.kube/config

    # Atlas>Artemis>Hermes gave the option to install postgresql@13 as an app,
    # and self-containment is teh win. But now I need the CLI tools in my path,
    # so...
    # export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/13/bin"

    # pnpm
    export PNPM_HOME="/Users/davidbrady/Library/pnpm"
    case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    # pnpm end

elif [ $IS_LINUX ]; then
    source /etc/profile.d/rvm.sh
    rvm default 3.4.5
elif [ $IS_OSX ]; then
    echo "~/.bash_profile: I see you're on OSX but NOT your usual work machine. ($HOSTNAME) That's weird, right? NOT setting rvm defaults."
else
    echo "~/.bash_profile has no clue what OS this is. So that's kinda neat...? I guess?"
fi

if [ $IS_OSX ]; then
    # I'll never let go of bash until they physically bar me from installing it.
    # zsh is NOT an acceptable bash unless you're not using any of bash's
    # features.  That said, I get why AAPL is doing this. bash going GPL v3
    # poses a genuine threat to the privacy of their OS. Oh wait I just
    # remembered I don't care
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # LOL THIS IS FOR MP ON Apple Silicon
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
fi


# 2025-07-22: Do I need this on OSX now? I know I need it on thinky and maybe theseus.
# Setup ssh agent
# ssh-add -L &> /dev/null
ssh-add -L >/dev/null 2>&1
if [ $? -eq 1 ]; then
    ssh-add
fi

# OSX-specific randomness
if [ $IS_OSX ]; then
    # for mtr (OSX)
    export PATH=$PATH:/usr/local/sbin

    term-birb

    # brew shellenv will dump all the homebrew variables. eval() on it will
    # export them into the current bash session.
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # NVM
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # plist startups
    # if [ $IS_OSX ]; then
    #   ls ~/bin/*.plist | while read plist; do echo launchctl load $plist; launchctl load $plist; done
    # fi

    #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    # --> Dave Says: FALSE. You just want it real bad. And you STILL can't have it.
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Linux-specific randomness
if [ $IS_LINUX ]; then
    export PATH=$HOME/.local/bin:$PATH
fi


# Final path fixups
if [ $IS_OSX ]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

# MY BIN FOLDER GOES FIRST, DAMMIT - I'm looking at you, homebrew/bin/go. Eat my shorts, go-lang.
if [[ $PATH != *"$HOME/bin"* ]]; then
    export PATH=$HOME/bin:$PATH
fi

# echo "bash_profile finished loading"
