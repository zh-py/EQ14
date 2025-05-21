LFCD="$HOME/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
 source "$LFCD"
fi

bindkey -s '^o' 'lfcd\n'  # zsh
#bindkey -viins
bindkey '^R' fzf-history-widget

source $HOME/.config/lf/lf.bash
