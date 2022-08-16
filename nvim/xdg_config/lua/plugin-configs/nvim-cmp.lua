local fn = vim.fn

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
end

local function tab(fallback)
  local luasnip = require "luasnip"
  if fn.pumvisible() == 1 then
    fn.feedkeys(t "<C-n>", "n")
  elseif luasnip.expand_or_jumpable() then
    fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
  elseif check_back_space() then
    fn.feedkeys(t "<tab>", "n")
  else
    fallback()
  end
end

local function shift_tab(fallback)
  local luasnip = require "luasnip"
  if fn.pumvisible() == 1 then
    fn.feedkeys(t "<C-p>", "n")
  elseif luasnip.jumpable(-1) then
    fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
  else
    fallback()
  end
end

local cmp = require "cmp"

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'path' },
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })[entry.source.name]
      return vim_item
    end,
  },
}
-- -- nvim-cmp and friends
-- local cmp = require'cmp'
-- cmp.setup({
--   completion = {
--     keyword_length = 2
--   },
--   snippet = {
--     expand = function(args)
--       --vim.fn["vsnip#anonymous"](args.body)
--       require'luasnip'.lsp_expand(args.body)
--     end,
--   },
--   mapping = {
--     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--   },
-- })
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
