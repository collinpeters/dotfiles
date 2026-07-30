-- titanium.lua — Neovim colorscheme ported from oh-my-pi's "titanium" theme.
-- Palette and syntax role mappings taken verbatim from omp's bundled theme
-- definition (packages/coding-agent, github.com/can1357/oh-my-pi).
--
-- Brushed-metal dark base, electric-blue accent, gold strings, green readouts.
-- Requires a true-color terminal: set `termguicolors`.

local p = {
  brushed_titanium = "#151820", -- page background
  dark_titanium    = "#0f1216", -- panels / floats / darker bg
  electric_blue    = "#00b4ff", -- primary accent: keywords, types, operators
  deep_blue        = "#0082b3", -- selection / visual
  titanium_gold    = "#d4c090", -- strings, constants
  bright_aluminum  = "#e8ecf4", -- primary text / variables
  dim_aluminum     = "#9ca3b0", -- muted text / punctuation
  warning_amber    = "#ffb347", -- numbers / git dirty / warnings
  readout_green    = "#00ff88", -- functions / git clean / success
  alert_red        = "#ff4757", -- errors
  subtle_gray      = "#2a3038", -- borders / separators
  border_muted     = "#1f252d",
  dim              = "#6b7280", -- comments / dim
  tool_error_bg    = "#1a0f10",
}

local function apply()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "titanium"
  vim.o.background = "dark"

  local hl = vim.api.nvim_set_hl
  local NONE = "NONE"

  local groups = {
    -- Editor UI
    Normal       = { fg = p.bright_aluminum, bg = p.brushed_titanium },
    NormalNC     = { fg = p.bright_aluminum, bg = p.brushed_titanium },
    NormalFloat  = { fg = p.bright_aluminum, bg = p.dark_titanium },
    FloatBorder  = { fg = p.subtle_gray, bg = p.dark_titanium },
    FloatTitle   = { fg = p.electric_blue, bg = p.dark_titanium, bold = true },
    ColorColumn  = { bg = p.dark_titanium },
    Cursor       = { fg = p.brushed_titanium, bg = p.electric_blue },
    CursorLine   = { bg = p.dark_titanium },
    CursorColumn = { bg = p.dark_titanium },
    CursorLineNr = { fg = p.electric_blue, bold = true },
    LineNr       = { fg = p.dim },
    SignColumn   = { bg = NONE },
    VertSplit    = { fg = p.subtle_gray },
    WinSeparator = { fg = p.subtle_gray },
    Folded       = { fg = p.dim_aluminum, bg = p.dark_titanium },
    FoldColumn   = { fg = p.dim },
    Visual       = { bg = p.deep_blue },
    VisualNOS    = { bg = p.deep_blue },
    Search       = { fg = p.brushed_titanium, bg = p.titanium_gold },
    IncSearch    = { fg = p.brushed_titanium, bg = p.electric_blue },
    CurSearch    = { fg = p.brushed_titanium, bg = p.electric_blue },
    MatchParen   = { fg = p.electric_blue, bold = true, underline = true },
    NonText      = { fg = p.subtle_gray },
    Whitespace   = { fg = p.subtle_gray },
    SpecialKey   = { fg = p.subtle_gray },
    EndOfBuffer  = { fg = p.brushed_titanium },
    Directory    = { fg = p.electric_blue },
    Title        = { fg = p.electric_blue, bold = true },
    Conceal      = { fg = p.dim_aluminum },

    -- Statusline / tabline / popup menu
    StatusLine   = { fg = p.bright_aluminum, bg = p.dark_titanium },
    StatusLineNC = { fg = p.dim_aluminum, bg = p.dark_titanium },
    TabLine      = { fg = p.dim_aluminum, bg = p.dark_titanium },
    TabLineFill  = { bg = p.brushed_titanium },
    TabLineSel   = { fg = p.electric_blue, bg = p.brushed_titanium, bold = true },
    WinBar       = { fg = p.bright_aluminum, bg = NONE },
    WinBarNC     = { fg = p.dim_aluminum, bg = NONE },
    Pmenu        = { fg = p.bright_aluminum, bg = p.dark_titanium },
    PmenuSel     = { fg = p.brushed_titanium, bg = p.electric_blue },
    PmenuSbar    = { bg = p.subtle_gray },
    PmenuThumb   = { bg = p.electric_blue },
    WildMenu     = { fg = p.brushed_titanium, bg = p.electric_blue },

    -- Messages
    ErrorMsg   = { fg = p.alert_red },
    WarningMsg = { fg = p.warning_amber },
    ModeMsg    = { fg = p.dim_aluminum },
    MoreMsg    = { fg = p.readout_green },
    Question   = { fg = p.readout_green },
    QuickFixLine = { bg = p.subtle_gray },

    -- Legacy syntax groups (mapped from omp titanium syntax roles)
    Comment        = { fg = p.dim, italic = true },
    Constant       = { fg = p.titanium_gold },
    String         = { fg = p.titanium_gold },
    Character      = { fg = p.titanium_gold },
    Number         = { fg = p.warning_amber },
    Float          = { fg = p.warning_amber },
    Boolean        = { fg = p.warning_amber },
    Identifier     = { fg = p.bright_aluminum },
    Function       = { fg = p.readout_green },
    Statement      = { fg = p.electric_blue },
    Conditional    = { fg = p.electric_blue },
    Repeat         = { fg = p.electric_blue },
    Label          = { fg = p.electric_blue },
    Operator       = { fg = p.electric_blue },
    Keyword        = { fg = p.electric_blue },
    Exception      = { fg = p.electric_blue },
    PreProc        = { fg = p.electric_blue },
    Include        = { fg = p.electric_blue },
    Define         = { fg = p.electric_blue },
    Macro          = { fg = p.electric_blue },
    Type           = { fg = p.electric_blue },
    StorageClass   = { fg = p.electric_blue },
    Structure      = { fg = p.electric_blue },
    Typedef        = { fg = p.electric_blue },
    Special        = { fg = p.titanium_gold },
    SpecialChar    = { fg = p.warning_amber },
    Delimiter      = { fg = p.dim_aluminum },
    Tag            = { fg = p.electric_blue },
    Todo           = { fg = p.brushed_titanium, bg = p.titanium_gold, bold = true },
    Error          = { fg = p.alert_red },
    Underlined     = { fg = p.electric_blue, underline = true },

    -- Treesitter
    ["@comment"]              = { link = "Comment" },
    ["@comment.error"]        = { fg = p.alert_red },
    ["@comment.warning"]      = { fg = p.warning_amber },
    ["@comment.todo"]         = { link = "Todo" },
    ["@comment.note"]         = { fg = p.electric_blue },
    ["@variable"]             = { fg = p.bright_aluminum },
    ["@variable.builtin"]     = { fg = p.electric_blue },
    ["@variable.parameter"]   = { fg = p.bright_aluminum },
    ["@variable.member"]      = { fg = p.bright_aluminum },
    ["@constant"]             = { fg = p.titanium_gold },
    ["@constant.builtin"]     = { fg = p.warning_amber },
    ["@constant.macro"]       = { fg = p.electric_blue },
    ["@string"]               = { fg = p.titanium_gold },
    ["@string.escape"]        = { fg = p.warning_amber },
    ["@string.special"]       = { fg = p.warning_amber },
    ["@character"]            = { fg = p.titanium_gold },
    ["@number"]               = { fg = p.warning_amber },
    ["@number.float"]         = { fg = p.warning_amber },
    ["@boolean"]              = { fg = p.warning_amber },
    ["@function"]             = { fg = p.readout_green },
    ["@function.builtin"]     = { fg = p.readout_green },
    ["@function.call"]        = { fg = p.readout_green },
    ["@function.macro"]       = { fg = p.electric_blue },
    ["@function.method"]      = { fg = p.readout_green },
    ["@function.method.call"] = { fg = p.readout_green },
    ["@constructor"]          = { fg = p.electric_blue },
    ["@keyword"]              = { fg = p.electric_blue },
    ["@keyword.function"]     = { fg = p.electric_blue },
    ["@keyword.operator"]     = { fg = p.electric_blue },
    ["@keyword.return"]       = { fg = p.electric_blue },
    ["@keyword.import"]       = { fg = p.electric_blue },
    ["@keyword.conditional"]  = { fg = p.electric_blue },
    ["@keyword.repeat"]       = { fg = p.electric_blue },
    ["@keyword.exception"]    = { fg = p.electric_blue },
    ["@operator"]             = { fg = p.electric_blue },
    ["@type"]                 = { fg = p.electric_blue },
    ["@type.builtin"]         = { fg = p.electric_blue },
    ["@type.definition"]      = { fg = p.electric_blue },
    ["@attribute"]            = { fg = p.titanium_gold },
    ["@property"]             = { fg = p.bright_aluminum },
    ["@field"]                = { fg = p.bright_aluminum },
    ["@punctuation.delimiter"] = { fg = p.dim_aluminum },
    ["@punctuation.bracket"]  = { fg = p.dim_aluminum },
    ["@punctuation.special"]  = { fg = p.warning_amber },
    ["@tag"]                  = { fg = p.electric_blue },
    ["@tag.attribute"]        = { fg = p.titanium_gold },
    ["@tag.delimiter"]        = { fg = p.dim_aluminum },
    ["@markup.heading"]       = { fg = p.electric_blue, bold = true },
    ["@markup.raw"]           = { fg = p.titanium_gold },
    ["@markup.link"]          = { fg = p.electric_blue, underline = true },
    ["@markup.link.url"]      = { fg = p.deep_blue, underline = true },
    ["@markup.list"]          = { fg = p.electric_blue },
    ["@markup.strong"]        = { bold = true },
    ["@markup.italic"]        = { italic = true },

    -- LSP semantic tokens
    ["@lsp.type.class"]     = { fg = p.electric_blue },
    ["@lsp.type.enum"]      = { fg = p.electric_blue },
    ["@lsp.type.interface"] = { fg = p.electric_blue },
    ["@lsp.type.struct"]    = { fg = p.electric_blue },
    ["@lsp.type.type"]      = { fg = p.electric_blue },
    ["@lsp.type.function"]  = { fg = p.readout_green },
    ["@lsp.type.method"]    = { fg = p.readout_green },
    ["@lsp.type.property"]  = { fg = p.bright_aluminum },
    ["@lsp.type.variable"]  = { fg = p.bright_aluminum },
    ["@lsp.type.parameter"] = { fg = p.bright_aluminum },
    ["@lsp.type.keyword"]   = { fg = p.electric_blue },
    ["@lsp.type.string"]    = { fg = p.titanium_gold },
    ["@lsp.type.number"]    = { fg = p.warning_amber },

    -- Diagnostics
    DiagnosticError = { fg = p.alert_red },
    DiagnosticWarn  = { fg = p.warning_amber },
    DiagnosticInfo  = { fg = p.electric_blue },
    DiagnosticHint  = { fg = p.dim_aluminum },
    DiagnosticOk    = { fg = p.readout_green },
    DiagnosticUnderlineError = { undercurl = true, sp = p.alert_red },
    DiagnosticUnderlineWarn  = { undercurl = true, sp = p.warning_amber },
    DiagnosticUnderlineInfo  = { undercurl = true, sp = p.electric_blue },
    DiagnosticUnderlineHint  = { undercurl = true, sp = p.dim_aluminum },
    DiagnosticVirtualTextError = { fg = p.alert_red, bg = p.tool_error_bg },
    DiagnosticVirtualTextWarn  = { fg = p.warning_amber, bg = p.dark_titanium },
    DiagnosticVirtualTextInfo  = { fg = p.electric_blue, bg = p.dark_titanium },
    DiagnosticVirtualTextHint  = { fg = p.dim_aluminum, bg = p.dark_titanium },

    -- Diff / git (GitClean->green, GitDirty->amber per omp titanium)
    DiffAdd    = { fg = p.readout_green, bg = p.dark_titanium },
    DiffChange = { fg = p.warning_amber, bg = p.dark_titanium },
    DiffDelete = { fg = p.alert_red, bg = p.dark_titanium },
    DiffText   = { fg = p.electric_blue, bg = p.subtle_gray },
    diffAdded   = { fg = p.readout_green },
    diffRemoved = { fg = p.alert_red },
    diffChanged = { fg = p.warning_amber },
    Added   = { fg = p.readout_green },
    Removed = { fg = p.alert_red },
    Changed = { fg = p.warning_amber },

    -- gitsigns
    GitSignsAdd    = { fg = p.readout_green },
    GitSignsChange = { fg = p.warning_amber },
    GitSignsDelete = { fg = p.alert_red },

    -- Spelling
    SpellBad   = { undercurl = true, sp = p.alert_red },
    SpellCap   = { undercurl = true, sp = p.warning_amber },
    SpellRare  = { undercurl = true, sp = p.electric_blue },
    SpellLocal = { undercurl = true, sp = p.readout_green },

    -- Telescope
    TelescopeBorder        = { fg = p.subtle_gray, bg = p.dark_titanium },
    TelescopeNormal        = { fg = p.bright_aluminum, bg = p.dark_titanium },
    TelescopePromptTitle   = { fg = p.brushed_titanium, bg = p.electric_blue, bold = true },
    TelescopeResultsTitle  = { fg = p.brushed_titanium, bg = p.readout_green, bold = true },
    TelescopePreviewTitle  = { fg = p.brushed_titanium, bg = p.titanium_gold, bold = true },
    TelescopeSelection     = { bg = p.subtle_gray },
    TelescopeMatching      = { fg = p.electric_blue, bold = true },

    -- nvim-cmp / blink
    CmpItemAbbr          = { fg = p.dim_aluminum },
    CmpItemAbbrMatch     = { fg = p.electric_blue, bold = true },
    CmpItemKind          = { fg = p.titanium_gold },
    BlinkCmpLabelMatch   = { fg = p.electric_blue, bold = true },

    -- WhichKey
    WhichKey       = { fg = p.electric_blue },
    WhichKeyGroup  = { fg = p.titanium_gold },
    WhichKeyDesc   = { fg = p.bright_aluminum },
    WhichKeySeparator = { fg = p.dim },
    WhichKeyFloat  = { bg = p.dark_titanium },

    -- neo-tree / nvim-tree
    NeoTreeNormal      = { fg = p.bright_aluminum, bg = p.dark_titanium },
    NeoTreeNormalNC    = { fg = p.bright_aluminum, bg = p.dark_titanium },
    NeoTreeDirectoryName = { fg = p.electric_blue },
    NeoTreeDirectoryIcon = { fg = p.electric_blue },
    NeoTreeGitModified = { fg = p.warning_amber },
    NeoTreeGitAdded    = { fg = p.readout_green },
    NeoTreeGitDeleted  = { fg = p.alert_red },

    -- indent guides
    IblIndent = { fg = p.border_muted },
    IblScope  = { fg = p.subtle_gray },
  }

  for group, spec in pairs(groups) do
    hl(0, group, spec)
  end

  -- Terminal colors
  vim.g.terminal_color_0  = p.brushed_titanium
  vim.g.terminal_color_8  = p.dim
  vim.g.terminal_color_1  = p.alert_red
  vim.g.terminal_color_9  = p.alert_red
  vim.g.terminal_color_2  = p.readout_green
  vim.g.terminal_color_10 = p.readout_green
  vim.g.terminal_color_3  = p.warning_amber
  vim.g.terminal_color_11 = p.titanium_gold
  vim.g.terminal_color_4  = p.electric_blue
  vim.g.terminal_color_12 = p.electric_blue
  vim.g.terminal_color_5  = p.deep_blue
  vim.g.terminal_color_13 = p.deep_blue
  vim.g.terminal_color_6  = p.electric_blue
  vim.g.terminal_color_14 = p.electric_blue
  vim.g.terminal_color_7  = p.bright_aluminum
  vim.g.terminal_color_15 = p.bright_aluminum
end

apply()
