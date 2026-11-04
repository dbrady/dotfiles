[[ -n "$__BASH_FUNCTIONS_LOADED" ]] && return
__BASH_FUNCTIONS_LOADED=1

# Add a path to PATH but only if it's not already in there:
add_to_path() {
  local dir="${1/#\~/$HOME}"
  if [[ ":$PATH:" != *":$dir:"* ]]; then
    export PATH="$dir:$PATH"
  fi
}

# Politely source file(s)
# source_files ~/.aliases \
#   ~/.bash_completions \
#   ~/.git-completion.bash \
#   ~/.nav \
#   ~/.private \
#   ~/.ps1_functions
#   ... etc
source_files()
{
    local file

    for file in "$@" ; do
        file=${file/\~\//$HOME\/} # Expand ~/

        if [[ -s "${file}" ]] ; then
            source "${file}"
        fi
    done

    return 0
}

# ----------------------------------------------------------------------
# makeline()
#
# 'makeline =' to make terminal width line. Or give 2nd arg count. By
# default prints a line of #'s as wide as the terminal.
#
# Credit due to @climagic:
# https://twitter.com/#!/climagic/status/168025763063406593
#
# Example:
# $ makeline = 40
# => ========================================
makeline() { printf "%${2:-$COLUMNS}s\n" ""|tr " " ${1:-#}; }

# ----------------------------------------------------------------------
# bundle()
#
# Intercept bare `bundle` (deprecated: bundler wants an explicit
# subcommand now). With args, pass straight through to the real bundle
# silently. With no args, delegate to `bfi`, which prints the warning +
# `bundle install` reminder and then runs it.
#
# WHY a function and not a PATH shim: RVM's bundle sits ahead of ~/bin in
# PATH, so a ~/bin/bundle script would never be reached. A function is
# resolved before PATH; `command bundle` bypasses this function to hit
# the real RVM binary without recursing.
bundle() {
    if (( $# == 0 )); then
        bundle-fucking-install
    else
        command bundle "$@"
    fi
}
