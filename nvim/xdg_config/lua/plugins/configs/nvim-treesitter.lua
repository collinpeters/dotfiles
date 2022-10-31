require'nvim-treesitter.configs'.setup {
  --ensure_installed = "all",
  highlight = {
    enable = true,              -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
    disable = { "perl", "javascript" },
  },
}
