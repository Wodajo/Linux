# minimal version. Modified kali zshrc works just fine on arch:D

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

# Show virtual environment name in prompt
autoload -U add-zsh-hook
add-zsh-hook chpwd() {
	emulate -L zsh
	if [[ -n "$VIRTUAL_ENV" ]]; then
		PS1="%{$fb_bold[green]}%(${VIRTUAL_ENV:t})%{%reset_color%} $PS1"
	else
		PS1="$PS1"
	fi
}


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

# append execution timer at right prompt
precmd () {
    if [ -n "$timer" ]; then
        TIMER=$((SECONDS - timer))
        if [ "$TIMER" -ge 3600 ]; then
            HOURS=$((TIMER / 3600))
            MINUTES=$(( (TIMER % 3600) / 60 ))
            SECONDS=$(( (TIMER % 3600) % 60 ))
            RPROMPT+=' [Exec Time: '${HOURS}h' '${MINUTES}m' '${SECONDS}s']'
        elif [ "$TIMER" -ge 60 ]; then
            MINUTES=$((TIMER / 60))
            SECONDS=$((TIMER % 60))
            RPROMPT+=' [Exec Time: '${MINUTES}m' '${SECONDS}s']'
        else
            RPROMPT+=' [Exec Time: '${TIMER}s']'
        fi
        unset timer
    fi
}


# Syntax autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
