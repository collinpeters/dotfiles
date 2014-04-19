# Don't resolve symlinks
export _Z_NO_RESOLVE_SYMLINKS=foo

_load_z() {
  source $1/z.sh
}

[[ -f $ZSH/plugins/z/z.plugin.zsh ]] && _load_z $ZSH/plugins/z
