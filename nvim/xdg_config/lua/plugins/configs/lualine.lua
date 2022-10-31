local _lualine, lualine = pcall(require, "lualine")

if not _lualine then
  print("Failed to load lualine.lua")
  return
end

--local gps = require("nvim-gps")

lualine.setup({
  --options = {theme = 'codedark'}
  options = {theme = 'monokaipro'}
})

--vim.cmd('set termguicolors')
--require('feline').setup()
