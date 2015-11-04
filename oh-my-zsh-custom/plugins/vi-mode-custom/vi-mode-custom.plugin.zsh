# http://zshwiki.org/home/zle/emacsandvikeys
bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down
bindkey "^[[7~" vi-beginning-of-line   # Home
bindkey "^[[8~" vi-end-of-line         # End

# Gnome-terminal
bindkey "^[OH" vi-beginning-of-line    # Home
bindkey "^[OF" vi-end-of-line          # End
bindkey '^[[3~' delete-char                # Del

bindkey "^R" history-incremental-search-backward
