local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "collinpeters/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
      "jsborjesson/vim-uppercase-sql",
    },
    ft = sql_ft,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_use_nvim_notify = true
    end,
    keys = {
      { "<leader>ds", function() require("utils.dadbod").select() end, desc = "[DB] Select database", ft = sql_ft },
      { "<leader>de", ":<C-u>lua require('utils.dadbod').execute_visual()<CR>", desc = "[DB] Execute selection", mode = "x", ft = sql_ft },
      { "<leader>del", function() require("utils.dadbod").execute_line() end, desc = "[DB] Execute line", ft = sql_ft },
      { "<leader>dea", function() require("utils.dadbod").execute_all() end, desc = "[DB] Execute all", ft = sql_ft },
      { "<leader>dd", ":<C-u>lua require('utils.dadbod').describe_table()<CR>", desc = "[DB] Describe table", mode = "x", ft = sql_ft },
      { "<leader>dc", ":<C-u>lua require('utils.dadbod').count_table()<CR>", desc = "[DB] Count table", mode = "x", ft = sql_ft },
    },
  },
  { -- blink.cmp completion source for SQL
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
}
