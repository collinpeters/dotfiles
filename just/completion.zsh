# just's own zsh completion, cached and regenerated whenever the just binary
# changes (fresh machine, upgrade). `j` completes too: complete_aliases is off.
(( $+commands[just] )) || return

just_completion=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/_just
if [[ ! -s $just_completion || $commands[just] -nt $just_completion ]]; then
  mkdir -p ${just_completion:h}
  just --completions zsh >| $just_completion
fi
source $just_completion
unset just_completion
