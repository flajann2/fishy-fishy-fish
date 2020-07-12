
# aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias em='emacs -nw'
alias nuke='tmux kill-session'
alias be='bundle exec'
alias bl='bundle list'
alias gits='git status -sb'
alias reload_bashrc='. ~/.bashrc'
alias mux='tmuxinator'

## My Raspberry Pis and other computers
alias deimos='ssh pi@deimos.local'
alias artemis='ssh pi@artemis.local'
alias noir='ssh pi@noir.local'
alias miranda='ssh miranda.local'

alias blankme='xset dpms force off'

# Elixir iex goodness for mix
alias iex="iex -S mix"

set -a fish_function_path "./.fish/functions"
