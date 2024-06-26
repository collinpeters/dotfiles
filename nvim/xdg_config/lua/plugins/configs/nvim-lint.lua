local _lint, lint = pcall(require, "lint")

if not _lint then
  print("Failed to load nvim-lint.lua")
  return
end

lint.linters_by_ft = {
  java = {'checkstyle',}
}
require('lint.linters.checkstyle').config_file = '/home/collin/dev/work/codestyle/checkstyle-checks/src/main/resources/sonatype/checkstyle-configuration.xml'

-- checkstyle lint on save .java files
vim.cmd("au BufWritePost <buffer> lua require('lint').try_lint()")
