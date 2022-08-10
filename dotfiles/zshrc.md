if on debian-base system - use modified kali linux .zshrc

```
HISTFILE="$ZDOTDIR/.zhistory"
HISTSIZE=1000
SAVEHIST=1000
# for now its emacs mode (-e flag), for vim change to -v
bindkey -e
# for changing delete key into delete character
bindkey "^[[3~" delete-char


# Tab autocompletion
# autoload load a file containig shell commands (zsh look for it in $fpath i.e. file search path) and loads compinit file.
autoload -Uz compinit
compinit

# Aliases
source $ZDOTDIR/.aliases

# Command execution time
#source $ZDOTDIR/command-execution-timer/command-execution-timer.zsh
#COMMAND_EXECUTION_TIMER_PREFIX=""
#COMMAND_EXECUTION_TIMER_FOREGROUND=57
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd append_command_execution_duration
# NOT WORKING :<

# Prompt
# %n username, %m machine, %/ pwd, %# # when root $ when regular
# colors added via start and stop sequences. %F{} and %f respectively
# PS1='%n@%m %F{green}%/%f %# ' # looks like arco@Neocortex ~ $
# vcs_info is a framework shipped with zsh for version control systems info gathering
#autoload -Uz vcs_info # enable vcs_info
#precmd() { vcs_info } # always load before displaying the prompt
# vcs_info are stored in vcs_info_msg_0_ variable
# we can use zstyle format string to format info
# %s current version control system, %b current branch
#zstyle ':vcs_info:*' formats '(%F{red}%b%f)' # main - stored in vcs_info_msg_0_ variable
#setopt prompt_subst
# Setting vcs checks was a failure:<
# You can use PS1 and PROMPT interchangeably. RPROMPT is on the right side
PS1='%n@%m %F{22}%/%f %# '
# dynamic prompt %(n?.<success expression>.<failure expression>). n=0 by default
# ? if the exit status of last command was n, j if the number of jobs is at least n
# %j nr. of current jobs
RPROMPT='%(1j.%F{21}%j%f.) %(?..%F{red}%?%f)'


# Syntax autosuggestions
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```
