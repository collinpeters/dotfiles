local _neotree, neotree = pcall(require, "neo-tree")

if not _neotree then
  print("Failed to load neo-tree.lua")
  return
end

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup {
  popup_border_style = "rounded",
  filesystem = {
    hijack_netrw_behavior = "open_current"
  },
  default_component_configs = {
    indent = {
      with_expanders = true,
    },
  },
  window = {
    mappings = {
      ["P"] = { "toggle_preview", config = { use_float = true } },
    }
  }
}
