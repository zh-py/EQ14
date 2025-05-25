LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi

bindkey -s '^o' 'lfcd\n'  # zsh
#bindkey -viins
bindkey '^R' fzf-history-widget

export EDITOR=nvim

setopt SHARE_HISTORY        # Share history instantly between sessions
setopt INC_APPEND_HISTORY   # Write commands to history file immediately
setopt HIST_IGNORE_ALL_DUPS # Ignore duplicated entries
setopt HIST_REDUCE_BLANKS

source $HOME/.config/lf/lf.bash
