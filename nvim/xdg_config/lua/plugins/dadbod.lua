local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "collinpeters/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = sql_ft, lazy = true },
      { "jsborjesson/vim-uppercase-sql", ft = sql_ft, lazy = true },
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

      -- Keymaps
      -- stylua: ignore start
      vim.keymap.set("x", "<Plug>(DBExe)", "db#op_exec()", { noremap = false, expr = true })
      vim.keymap.set("n", "<Plug>(DBExeLine)", "db#op_exec() . '_'", { noremap = false, expr = true })
      vim.keymap.set("n", "<Plug>(DBExeAll)", "db#op_exec() . ':<c-u>normal! mzggVG<cr>`z'", { noremap = false, expr = true })
      vim.keymap.set("x", "<Plug>(DBDescribeTable)", "DBDescribeTable()", { noremap = true, expr = true, })
      vim.keymap.set("x", "<Plug>(DBCountTable)", "DBCountTable()", { noremap = true, expr = true, })
      -- stylua: ignore end

      --vim.keymap.set("x", "<leader>de", "<Plug>(DBExe)", {})
      --vim.keymap.set("n", "<leader>del", "<Plug>(DBExeLine)", {})
      --vim.keymap.set("n", "<leader>dea", "<Plug>(DBExeAll)", {})
      --vim.keymap.set("x", "<leader>dd", "<Plug>(DBDescribeTabl)", {})

      vim.cmd("source ~/.config/nvim/lua/plugins/dadbod.vim")

      -- for dadbod-ui
      vim.g.dbs = {
      -- stylua: ignore start
      { name = "local iq", url = "postgres://iq-app@localhost/iq" },
      { name = "local mtiq", url = "postgres://mtiq-app@localhost/mtiq" },
      { name = "mtiq-dev-1-db RW", url = "postgres://mtiq-admin@mtiq-dev-1-db-us-east-2.cluster-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-dev-1-db", url = "postgres://mtiq-admin@mtiq-dev-1-db-us-east-2.cluster-ro-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-ci-1-db RW", url = "postgres://mtiq-admin@mtiq-ci-1-db-us-east-2.cluster-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-ci-1-db", url = "postgres://mtiq-admin@mtiq-ci-1-db-us-east-2.cluster-ro-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-staging-1-db RW", url = "postgres://mtiq-admin@mtiq-staging-1-db-us-east-2.cluster-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-staging-1-db", url = "postgres://mtiq-admin@mtiq-staging-1-db-us-east-2.cluster-ro-ckxkxl7a0st8.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-us-1-db RW", url = "postgres://mtiq-admin@mtiq-prod-us-1-db-us-east-2.cluster-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-us-1-db", url = "postgres://mtiq-admin@mtiq-prod-us-1-db-us-east-2.cluster-ro-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-us-2-db RW", url = "postgres://mtiq-admin@mtiq-prod-us-2-db-us-east-2.cluster-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-us-2-db", url = "postgres://mtiq-admin@mtiq-prod-us-2-db-us-east-2.cluster-ro-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-internal-db RW", url = "postgres://mtiq-admin@mtiq-prod-internal-db-us-east-2.cluster-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "mtiq-prod-internal-db", url = "postgres://mtiq-admin@mtiq-prod-internal-db-us-east-2.cluster-ro-ciye03gbs87f.us-east-2.rds.amazonaws.com/mtiq" },
      { name = "hds-staging-datamart", url = "mysql://iq-dev@hds-staging-us-east-2-datamart.cluster-ro-ccbtljn6jsbm.us-east-2.rds.amazonaws.com/insight_dm" },
        -- stylua: ignore end
      }
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
