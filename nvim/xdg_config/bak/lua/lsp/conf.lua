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
  vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapBreakpointRejected', {text='🔵', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

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
--   };
-- }

  local root_markers = {'.project', '.git'}
	local root_dir = require('jdtls.setup').find_root(root_markers)
	local home = os.getenv('HOME')
	-- the "project id" is the root .git directory prefixed with its parent directory. This is to accomodate git worktrees
	local project_id = vim.fn.fnamemodify(root_dir, ':p:h:h:t') .. '_' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
	local workspace_folder = home .. '/dev/lsp-workspace/' .. project_id

  local config = {}
  -- Run our custom jdtls.sh and give it a workspace based on the filename
  config.cmd = {'jdtls.sh', workspace_folder}
  config.on_attach = jdtls_on_attach
  config.settings = {
    java = {
      format = {
        settings = {
          url = home .. "/dev/work/codestyle/sonatype-eclipse.xml"
        }
      },
      settings = {
        url = home .. "/dev/work/org.eclipse.jdt.core.prefs"
      }
    }
  }

  local jar_patterns = {
    '/home/collin/dev/home/nvim-infra/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
-- TODO   '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
    '/home/collin/dev/home/nvim-infra/vscode-java-test/server/*.jar'
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
    }
  }
end

return M

