#!/bin/sh

. ~/.bash_functions

source_files ~/.aliases \
  ~/.bash_completions \
  ~/.current-project \
  ~/.git-completion.bash \
  ~/.hue.conf \
  ~/.nav \
  ~/.private \
  ~/.ps1_functions

source_files ~/.env

if [ -e $HOME/.env ]; then
    # Check for this machine's config and load it up - put OS_NAME and IS_(OS) in here etc.
    source_files ~/.env
else
    # Figure out operating system & machine
    OS_NAME=$(uname -s)

    # My clanker dockers get IS_CLANKER to distinguish them from home linux.
    IS_OSX=false
    IS_LINUX=false
    IS_WINDOWS=false # tbd, may prefer IS_DOCKER or IS_WSL etc
    IS_ACIMA=false

    if [ "$(hostname)" = "Simples-MacBook-Pro.local" ]; then
    # if [ "$(hostname)" = "Mac" ]; then
        echo -e '\033[1;37;41m *** LOOKS LIKE YOU ARE ON YOUR WORK MACHINE BUT .env IS NOT SET! GO DO THIS SOONER RATHER THAN LATER: ***\033[0m'
        echo 'ln -s ~/dotfiles/.acima.env ~/.env'
        IS_ACIMA=true
    fi
fi

# TODO: move to .env files
case "$OS_NAME" in
    Darwin)
        IS_OSX=true
        CURRENT_RUBY_DEV_VERSION=3.4.9
        ;;
    Linux)
        IS_LINUX=true
        CURRENT_RUBY_DEV_VERSION=3.4.9
        ;;
    CYGWIN*|MINGW*|MSYS*)
        # YAGNI? Do I ever hit this on WSL or Docker under windows?
        IS_WINDOWS=true
        ;;
    *)
        echo -e "\033[1;37;41mCannot identify your operating system: '$OS_NAME'\033[0m"
        ;;
esac

# if [ $IS_OSX = true;     then echo "This OS looks like OSX.";     fi
# if [ $IS_LINUX = true ];   then echo "This OS looks like LINUX.";   fi
# if [ $IS_WINDOWS = true ]; then echo "This OS looks like WINDOWS."; fi

# TODO: move to .env
HOSTNAME=$(hostname)

export EDITOR=tem
export GEMEDITOR=$(echo `which emacs` -nw)
export CVSEDITOR=tem
export SVN_EDITOR=tem

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

# Doesn't work on OSX - Test on linux, move to linux env or remove
GREP_OPTIONS='--color=auto'
GREP_COLOR='1;32'

# ----------------------------------------------------------------------
# Terminal colours (after installing GNU coreutils)
# Doesn't work on OSX - Test on linux, move to linux env or remove
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;37m\]" #change this for letter colors
HII="\[\033[0;31m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

export HISTFILESIZE=10000

add_to_path ~/private_bin

source_files ~/.aliases \
  ~/.bash_completions \
  ~/.current-project \
  ~/.git-completion.bash \
  ~/.hue.conf \
  ~/.nav \
  ~/.private \
  ~/.ps1_functions

# Turn on path completion for my go command.
# This must come after git-completion.bash.
# ~/bin/go is my git checkout helper. Bite me, golang. ;-)
#
# Dear Future Dave: If you ever learn go, I trust you to do the right
# thing. --Love, Past Dave
complete -o default -o nospace -F _git_checkout go

# PS1 EMOJIS

case "$HOSTNAME" in
    Mac|Simples-MacBook-Pro.local)
        ps1_set \$
        export PS2='\\$\\$'
        source_files ~/.nav.work

        # 2025-08-26 dbrady - turning this off, let $ fall through
        # ps1_set --prompt "💳"
        # export PS2=💳💳
        ;;
    thinky)
        ps1_set --prompt "🧠"
        export PS2=🧠💭
        source_files ~/.nav.home
        ;;
    theseus)
        ps1_set --prompt "$"
        export PS2='$$'
        source_files ~/.nav.home
        ;;
    vapor)
        ps1_set --prompt '$'
        export PS2='\$\$ '
        source_files ~/.nav.home
        ;;
    clanker*)
        export PS2='$$'
        ;;
    *)
      ps1_set --prompt '$'
      export PS2='$$'
      echo -e "\033[1;37;41mNEW MACHINE: It's \D{%H} O'Clock! Check .bash_profile and/or .ps1_functions. Do you have my dotfiles repo?\033[0m"
        ;;
esac

# BEGIN rvm
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
    rvm default $CURRENT_RUBY_DEV_VERSION > /dev/null

    if [ -f .ruby-version ] && [ -f .ruby-gemset ]; then
        rvm use "$(cat .ruby-version)@$(cat .ruby-gemset)" > /dev/null 2>&1
    elif [ -f .ruby-version ]; then
        rvm use "$(cat .ruby-version)" > /dev/null 2>&1
    else
        rvm use "$CURRENT_RUBY_DEV_VERSION" > /dev/null 2>&1
    fi
fi
# END rvm

# BEGIN Acima
if [ $IS_ACIMA = true ]; then
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

    # fnm (for ams)
    # eval "$(fnm env --use-on-cd --shell bash)"

    # I'll never let go of bash until they physically bar me from installing it.
    # zsh is NOT an acceptable bash unless you're not using any of bash's
    # features. That said, I get why AAPL is doing this. bash going GPL v3 poses
    # a genuine threat to the privacy of their OS. Oh wait I just remembered I
    # don't care
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # LOL THIS IS FOR MP ON Apple Silicon
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
elif [ $IS_ACIMA = true ]; then
    echo "~/.bash_profile: I see you're on OSX but NOT your usual work machine. ($HOSTNAME) That's weird, right? NOT setting rvm defaults."
fi
# END Acima

# BEGIN MIDDLE GLOBAL
# Setup ssh agent
# ssh-add -L &> /dev/null
ssh-add -L >/dev/null 2>&1
if [ $? -eq 1 ]; then
    ssh-add
fi
# END MIDDLE GLOBAL

# BEGIN OSX-specific randomness
if [ $IS_ACIMA = true ]; then

    if [[ $PATH != *"$HOME/.local/bin"* ]]; then
        export PATH=$PATH:$HOME/.local/bin
    fi

    # for mtr (OSX)
    if [[ $PATH != *"/usr/local/sbin"* ]]; then
        export PATH=$PATH:/usr/local/sbin
    fi

    if [[ $PATH != *"$HOME/bin"* ]]; then
    export PATH=$HOME/bin:$PATH
fi


    if [ -t 1 ]; then
        command -v term-birb >/dev/null && term-birb
    fi

    # brew shellenv will dump all the homebrew variables. eval() on it will
    # export them into the current bash session.
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # NVM
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # plist startups
    # if [ $IS_OSX = true ]; then
    #   ls ~/bin/*.plist | while read plist; do echo launchctl load $plist; launchctl load $plist; done
    # fi

    #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    # --> Dave Says: FALSE. You just want it real bad. And you STILL can't have it.
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
# END OSX-specific randomness

# BEGIN Linux-specific randomness
if [ $IS_LINUX = true ]; then
    if [ $HOSTNAME == "vapor" ]; then
        source "/home/dbrady/.openclaw/completions/openclaw.bash"
    else
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        nvm use --lts
        nvm alias default 'lts/*'
    fi
fi
# END Linux-specific randomness

# Final path fixups
if [ $IS_ACIMA = true ]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

# Added by Antigravity
# export PATH="/Users/davidbrady/.antigravity/antigravity/bin:$PATH"

# MY BIN FOLDER GOES FIRST, DAMMIT - I'm looking at you, rvm. And homebrew. And
# go-lang. Especially go-lang, thinking you can get in front of MY go
# command. :-P
if [[ $PATH != *"$HOME/bin"* ]]; then
    export PATH=$HOME/bin:$PATH
fi


# I have stanned so hard for spring. Tahoe has finally broken me.
export DISABLE_SPRING=1
export DISABLE_DEV_BOOTUP_OPTIMIZATIONS=true

# echo "bash_profile finished loading"


# Added by Antigravity CLI installer
export PATH="/home/dbrady/.local/bin:$PATH"
