local root_markers = {'.project', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')
-- the "project id" is the root .git directory prefixed with its parent directory. This is to accomodate git worktrees
local project_id = vim.fn.fnamemodify(root_dir, ':p:h:h:t') .. '_' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_folder = home .. '/dev/lsp-workspace/' .. project_id

local nvimInfraHome = home .. '/dev/home/nvim-infra/'
local jar_patterns = {
  nvimInfraHome .. '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
  -- TODO   '/dev/dgileadi/vscode-java-decompiler/server/*.jar',
  nvimInfraHome .. '/vscode-java-test/server/*.jar'
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

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java', -- use whichever java is on the path (use sdkman)
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- use arch installed jdtls
    '-jar', '/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    '-configuration', home .. '/dev/lsp-config_linux',

    '-data', workspace_folder
  },

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
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
  },


  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
