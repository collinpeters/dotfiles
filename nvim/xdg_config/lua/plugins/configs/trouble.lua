local _trouble, trouble = pcall(require, "trouble")

if not _trouble then
  print("Failed to load trouble.lua")
  return
end

-- until lspsaga is enabled - https://github.com/folke/trouble.nvim/issues/52
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require("trouble").setup()
