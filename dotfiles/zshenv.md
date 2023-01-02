```
# Place for ENV of all zsh sessions

# XDG Base Directory specification defines where certain files are located
# only XDG_RUNTIME_DIR is set by default (via pam_systemd)

# where user-specific conf should be written (/etc analogue)
export XDG_CONFIG_HOME="$HOME/.config"
# where user-specific data files should be written (/usr/share analogue)?
export XDG_DATA_HOME="$XDG_CONFIG_HOME/.local/share"
# where user-specific non-essential (cached) data should be written (/var/cache analogue)
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# default text editor
export EDITOR="vim"

# zsh ENVs
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
```