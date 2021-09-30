local jdtls = require 'jdtls'
local api = vim.api
local M = {}

-- https://github.com/mfussenegger/nvim-jdtls/wiki/UI-Extensions
-- use telescope for code actions etc...
local function jdtls_setup_ui()
  local finders = require'telescope.finders'
  local sorters = require'telescope.sorters'
  local actions = require'telescope.actions'
  local pickers = require'telescope.pickers'
  require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
    local opts = {}
    pickers.new(opts, {
      prompt_title = prompt,
      finder    = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = label_fn(entry),
            ordinal = label_fn(entry),
          }
        end,
      },
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = actions.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)

          cb(selection.value)
        end)

        return true
      end,
    }):find()
  end
end

local function on_attach(client, bufnr, attach_opts)

  require "lsp_signature".on_attach()

  -- =========================================================
  -- general navigation actions for all LSP clients
  -- =========================================================
  -- 'go to' navigation
  --map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')  -- not supported by jdtls
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', 'gK', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

  -- find style navigation
  map('n', '<leader>u', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>') -- usages
  --map('n', '<leader>go', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>') -- not too useful

  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')

  map('n', '<leader>gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  map('n', '<leader>gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  -- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
  -- use this jdtls mapping also with other non-jdtls language servers
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts) -- see jdtls refactor below
  map("n", "<a-CR>", "<Cmd>lua require'jdtls'.code_action()<CR>")
  map("n", "<leader>r", "<Cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>")
  map("v", "<a-CR>", "<Esc><Cmd>lua require'jdtls'.code_action(true)<CR>")
  map("v", "<leader>r", "<Esc><Cmd>lua require'jdtls'.code_action(true, 'refactor')<CR>")

  map('n', '<leader>b', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
  map('n', '<leader>B', '<Cmd>lua require"dap".toggle_breakpoint(vim.fn.input("Breakpoint Condition: "), nil, nil, true)<CR>')
  map('n', '<f7>', '<cmd>lua require"dap".step_into()<CR>')
  map('n', '<f8>', '<cmd>lua require"dap".step_over()<CR>')
  map('n', '<shift><f8>', '<cmd>lua require"dap".step_out()<CR>')
  map('n', '<f9>', '<cmd>lua require"dap".continue()<CR>')
  --map('n', '<leader>lp', '<Cmd> require'me.dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '), true)<CR>

 map('n', "]d", '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
 map('n', "[d", '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

  -- require('lsp_compl').attach(client, bufnr, attach_opts)
  -- api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
  -- api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- api.nvim_buf_set_option(bufnr, "bufhidden", "hide")
  --
-- if client.resolved_capabilities.goto_definition then
--   api.nvim_buf_set_option(bufnr, 'tagfunc', "v:lua.require'me.lsp.ext'.tagfunc")
-- end
-- local opts = { silent = true; }
-- for _, mappings in pairs(key_mappings) do
--   local capability, mode, lhs, rhs = unpack(mappings)
--   if client.resolved_capabilities[capability] then
--     api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
--   end
-- end
-- api.nvim_buf_set_keymap(bufnr, "n", "<space>", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
-- api.nvim_buf_set_keymap(bufnr, "n", "crr", "<Cmd>lua vim.lsp.buf.rename(vim.fn.input('New Name: '))<CR>", opts)
-- api.nvim_buf_set_keymap(bufnr, "i", "<c-n>", "<Cmd>lua require('lsp_compl').trigger_completion()<CR>", opts)
-- vim.cmd('augroup lsp_aucmds')
-- vim.cmd(string.format('au! * <buffer=%d>', bufnr))
-- vim.cmd(string.format('au User LspDiagnosticsChanged <buffer=%d> redrawstatus!', bufnr))
-- vim.cmd(string.format('au User LspMessageUpdate <buffer=%d> redrawstatus!', bufnr))
-- if client.resolved_capabilities['document_highlight'] then
--   vim.cmd(string.format('au CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
--   vim.cmd(string.format('au CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()', bufnr))
--   vim.cmd(string.format('au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()', bufnr))
-- end
-- if vim.lsp.codelens and client.resolved_capabilities['code_lens'] then
--   -- vim.cmd(string.format('au BufEnter,BufModifiedSet,InsertLeave <buffer=%d> lua vim.lsp.codelens.refresh()', bufnr))
--   api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opts)
--   api.nvim_buf_set_keymap(bufnr, "n", "<leader>ce", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
-- end
-- vim.cmd('augroup end')
end

local function jdtls_on_attach(client, bufnr)
    on_attach(client, bufnr)
    local opts = { silent = true; }
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    --require('jdtls.dap').setup_dap_main_class_configs()
    jdtls.setup.add_commands()

    map("n", "<leader>xt", "<Cmd>lua require'jdtls'.test_class()<CR>") -- eXecute Test
    map("n", "<leader>xT", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>") 

    jdtls_setup_ui()

    -- jdtls specific maps
    -- api.nvim_buf_set_keymap(bufnr, "n", "<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
    -- api.nvim_buf_set_keymap(bufnr, "v", "crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
    -- api.nvim_buf_set_keymap(bufnr, "n", "crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    -- api.nvim_buf_set_keymap(bufnr, "v", "crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
end

function M.start_jdt()
  print("starting jdt")
-- local root_markers = {'gradlew', '.git'}
-- local root_dir = require('jdtls.setup').find_root(root_markers)
-- local home = os.getenv('HOME')
-- local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
-- local config = mk_config()
-- config.flags.server_side_fuzzy_completion = true
-- config.settings = {
--   java = {
--     signatureHelp = { enabled = true };
--     contentProvider = { preferred = 'fernflower' };
--     completion = {
--       favoriteStaticMembers = {
--         "org.hamcrest.MatcherAssert.assertThat",
--         "org.hamcrest.Matchers.*",
--         "org.hamcrest.CoreMatchers.*",
--         "org.junit.jupiter.api.Assertions.*",
--         "java.util.Objects.requireNonNull",
--         "java.util.Objects.requireNonNullElse",
--         "org.mockito.Mockito.*"
--       }
--     };
--     sources = {
--       organizeImports = {
--         starThreshold = 9999;
--         staticStarThreshold = 9999;
--       };
--     };
--     codeGeneration = {
--       toString = {
--         template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
--       }
--     };
--     configuration = {
--       runtimes = {
--         {
--           name = "JavaSE-11",
--           path = "/usr/lib/jvm/java-11-openjdk/",
--         },
--         {
--           name = "JavaSE-15",
--           path = "/usr/lib/jvm/java-15-openjdk/",
--         },
--       }
--     };
--   };
-- }

  local config = {}
  -- Run our custom jdtls.sh and give it a workspace based on the filename
  config.cmd = {'jdtls.sh', '/home/collin/Code/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')}
  config.on_attach = jdtls_on_attach
  config.settings = {
    ['java.format.settings.url'] = "/home/collin/Code/sonatype/1/codestyle/sonatype-eclipse.xml"
  }

  local jar_patterns = {
    '/home/collin/Code/nvim-infra/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
-- TODO   '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
    '/home/collin/Code/nvim-infra/vscode-java-test/server/*.jar'
  }
  local bundles = {}
  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
      -- exclude this jar as it is not a bundle
      if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
        table.insert(bundles, bundle)
      end
    end
  end
  --  TODO - what is this?
  --  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  --  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
  config.init_options = {
    bundles = bundles;
    --    extendedClientCapabilities = extendedClientCapabilities;
  }
  --vim.api.nvim_echo({{'first chunk and ', 'None'}, {'second chunk to echo', 'None'}}, true, {})
  --vim.api.nvim_err_writeln("test")
  jdtls.start_or_attach(config)
end

function M.setup()
  require('dap').configurations.java = {
    {
      type = 'java';
      request = 'attach';
      name = "Debug (Attach) - Remote";
      hostName = "127.0.0.1";
      port = 5005;
    },
  }
  require("dapui").setup()
--  require('jdtls.ui').pick_one_async = require('fzy').pick_one -- currently using telescope
-- require('jdtls').jol_path = os.getenv('HOME') .. '/apps/jol.jar'
-- require('me.lsp.conf').setup()
-- require('hop').setup()
-- require('lint').linters_by_ft = {
--   markdown = {'vale'},
--   rst = {'vale'},
--   java = {'codespell'},
--   lua = {'codespell', 'luacheck'},
--   sh = {'shellcheck'},
--   ['yaml.ansible'] = {'ansible_lint'},
-- }
--
-- U = M
-- P = function(...)
--   print(unpack(vim.tbl_map(vim.inspect, {...})))
-- end
-- PL = function(...)
--   local log_date_format = "%FT%H:%M:%S%z"
--   local fp = io.open('/tmp/nvim-debug.log', 'a+')
--   local line = table.concat(vim.tbl_map(vim.inspect, {...}), ', ')
--   fp:write('[' .. os.date(log_date_format) .. '] ' .. line .. '\n')
--   fp:flush()
--   fp:close()
-- end
-- local debug_view = nil
-- PB = function(...)
--   if not debug_view then
--     debug_view = require('dap.ui').new_view(
--       function()
--         return api.nvim_create_buf(false, true)
--       end,
--       function(buf)
--         vim.cmd('split')
--         api.nvim_win_set_buf(0, buf)
--         return api.nvim_get_current_win()
--       end
--     )
--   end
--   debug_view.open()
--   local text = table.concat(vim.tbl_map(vim.inspect, {...}), ', ')
--   local lines = vim.split(vim.trim(text), '\n')
--   vim.fn.appendbufline(debug_view.buf, '$', lines)
-- end
end

return M

-- vim.lsp.buf.clear_references()
-- vim.lsp.buf.completion()
-- vim.lsp.buf.document_highlight()
-- vim.lsp.buf.formatting()
-- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
-- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
-- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
-- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
-- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts) 
   
--
-- --	" LSP config (the mappings used in the default file don't quite work right)
-- --	nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
-- --	nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
--
-- --
-- -- nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
-- -- nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
-- -- vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
-- -- nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
-- -- vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
-- -- vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
