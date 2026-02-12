local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "collinpeters/vim-dadbod" },
      { "kristijanhusak/vim-dadbod-completion" },
      { "jsborjesson/vim-uppercase-sql" },
    },
    ft = sql_ft,
    keys = {
      -- stylua: ignore start
      { "<leader>ds", "<Cmd>lua require'utils.db-select'.select()<Cr>", desc = "[DB/SQL] Database Selection", buffer = true, },
      { "<leader>de", "<Plug>(DBExe)<CR>", desc = "[DB/SQL] Execute", mode = "x", buffer = true },
      { "<leader>del", "<Plug>(DBExeLine)<CR>", desc = "[DB/SQL] Execute line", buffer = true },
      { "<leader>dea", "<Plug>(DBExeAll)<CR>", desc = "[DB/SQL] Execute all", buffer = true },
      { "<leader>dd", "<Plug>(DBDescribeTable)<CR>", desc = "[DB/SQL] Describe Table", mode = "x", buffer = true },
      { "<leader>dc", "<Plug>(DBCountTable)<CR>", desc = "[DB/SQL] Count Table", mode = "x", buffer = true },
      -- stylua: ignore end
    },
    cmd = {
      "DB",
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- DBUI configuration
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_use_nvim_notify = true

      -- for dadbod-ui
      vim.g.dbs = {
        -- stylua: ignore start
        -- stylua: ignore end
      }
    end,
    config = function()
      -- Load helper functions for describe/count
      vim.cmd("source ~/.config/nvim/lua/plugins/dadbod.vim")

      -- Keymaps - set up AFTER plugins are loaded
      -- stylua: ignore start
      vim.keymap.set("x", "<Plug>(DBExe)", "db#op_exec()", { noremap = false, expr = true })
      vim.keymap.set("n", "<Plug>(DBExeLine)", "db#op_exec() . '_'", { noremap = false, expr = true })
      vim.keymap.set("n", "<Plug>(DBExeAll)", "db#op_exec() . ':<c-u>normal! mzggVG<cr>`z'", { noremap = false, expr = true })
      vim.keymap.set("x", "<Plug>(DBDescribeTable)", "DBDescribeTable()", { noremap = true, expr = true, })
      vim.keymap.set("x", "<Plug>(DBCountTable)", "DBCountTable()", { noremap = true, expr = true, })
      -- stylua: ignore end
    end,
  },
  { -- optional saghen/blink.cmp completion source
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
}
