local jdtls    = require("jdtls")
local handlers = require("lsp.handlers")

local function jdtls_on_attach(client, bufnr)
  handlers.on_attach(client, bufnr)
  if client.name == "jdtls" then
    jdtls = require("jdtls")
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()
    -- Auto-detect main and setup dap config
    require("jdtls.dap").setup_dap_main_class_configs({ config_overrides = {
      vmArgs = "-Dspring.profiles.active=local",
    } })
  end
end

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local home = os.getenv("HOME")
local share_dir = home .. "/.local/share"
local infra_dir = home .. "/dev/nvim-infra"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = share_dir .. "/eclipse/" .. project_name

local jar_patterns = {
  infra_dir .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
  -- TODO   '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
  infra_dir .. '/vscode-java-test/server/*.jar'
}
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
    -- exclude this jar as it is not a bundle
    --if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
    if not bundle:find('java.test.runner', 1, true) then
      table.insert(bundles, bundle)
    end
  end
end

local config = {
  -- Run our custom jdtls.sh and give it a workspace based on the filename
  cmd = {'jdtls.sh', workspace_folder},
  capabilities = handlers.capabilities,
  on_attach = jdtls_on_attach,
  on_init = on_init,
  init_options = {
    bundles = bundles,
  },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true
  },
  root_dir = jdtls.setup.find_root({".git" }),
  settings = {
    java = {
      format = {
        settings = {
          url = home .. "/dev/work/codestyle/sonatype-eclipse.xml"
        }
      },
      settings = {
        url = home .. "/dev/work/org.eclipse.jdt.core.prefs"
      },
      signatureHelp = {
        enabled = true
      },
      saveActions = {
        organizeImports = true
      },
      completion = {
        maxResults = 20,
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        }
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999
        }
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        }
      },
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/home/collin/.sdkman/candidates/java/8.0.345-tem",
          },
          {
            name = "JavaSE-11",
            path = "/home/collin/.sdkman/candidates/java/11.0.12-open/",
          },
          {
            name = "JavaSE-17",
            path = "/home/collin/.sdkman/candidates/java/17.0.2-open/",
          },
        }
      }
    }
  }
}

local M = {}

M.start = function()
 jdtls.start_or_attach(config)
end

return M
