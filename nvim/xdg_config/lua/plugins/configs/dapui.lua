local _dapui, dapui = pcall(require, "dapui")

if not _dapui then
  print("Failed to load dapui.lua")
  return
end

require('dapui').setup({
  layouts = {
    {
      elements = {
        'scopes',
        'breakpoints',
        'stacks',
        'watches',
      },
      size = 60,
      position = 'left',
    },
    {
      elements = {
        'repl',
        'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
})
