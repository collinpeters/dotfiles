-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- disable LazyVim override of shift-h & shift-l for buffer switching
-- defaults for top/bottom of file
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- Clear the search buffer
vim.keymap.set("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- System clipboard mappings
vim.keymap.set("v", "<leader>y", '"+y', { desc = "System copy" })
vim.keymap.set("v", "<leader>d", '"+d', { desc = "System cut" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "System paste after" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "System paste before" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "System paste after" })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "System paste before" })

-- delete snacks profile keymaps as they conflict with custom db keymaps
vim.keymap.del("n", "<leader>dph")
vim.keymap.del("n", "<leader>dpp")
vim.keymap.del("n", "<leader>dps")

-- ============================================================================
-- IdeaVim-mirrored keymaps (native Neovim)
-- Ported from ~/.config/ideavim/ideavimrc. Goal: IntelliJ muscle memory for
-- LSP-level navigation. Run/debug/build intentionally omitted (run from
-- console, debug in IntelliJ). Java LSP via lazyvim.plugins.extras.lang.java.
--
-- Where a mapping overrides a LazyVim default, the default is noted inline for
-- reference (kept, not used).
-- ============================================================================

local map = vim.keymap.set

-- Small helper: prefer a jdtls-aware handler for Java, else the LSP fallback.
local function java_or(lsp_fn, jdtls_method)
  return function()
    local ok, jdtls = pcall(require, "jdtls")
    if ok and vim.bo.filetype == "java" and jdtls[jdtls_method] then
      jdtls[jdtls_method]()
    else
      lsp_fn()
    end
  end
end

-- ----------------------------------------------------------------------------
-- <leader>o : Open / search / find   (ideavimrc: SearchEverywhere etc.)
-- ----------------------------------------------------------------------------
map("n", "<leader>oe", function()
  Snacks.picker.smart()
end, { desc = "Search everywhere" })
map("n", "<leader>oa", function()
  Snacks.picker.commands()
end, { desc = "Search for action" })
map("n", "<leader>oc", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "Search for class" })
map("n", "<leader>of", function()
  Snacks.picker.files()
end, { desc = "Search for file" })
map("n", "<leader>og", function()
  Snacks.picker.grep()
end, { desc = "Grep in files" })
map("n", "<leader>or", function()
  Snacks.picker.recent()
end, { desc = "Recent files" })
map("n", "<leader>os", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Goto symbol" })

-- ----------------------------------------------------------------------------
-- <leader>g : Goto / jumps   (ideavimrc: GotoDeclaration etc.)
-- LazyVim default <leader>g* = git prefix (lazygit <leader>gg, git log <leader>gl,
--   git blame <leader>gb, git browse <leader>gB/gY). Overridden below.
-- Vim-idiomatic LSP jumps gd/gr/gI/gy/gD from LazyVim are kept as-is.
-- ----------------------------------------------------------------------------
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Goto declaration" })
map("n", "<leader>gK", vim.lsp.buf.type_definition, { desc = "Goto type declaration" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Goto implementation" })
map("n", "<leader>gs", java_or(vim.lsp.buf.definition, "super_implementation"), { desc = "Goto super method" })
-- GotoTest / GotoRelated: no clean native equivalent without extra tooling.
-- map("n", "<leader>gt", ...)  -- ideavim: GotoTest
-- map("n", "<leader>gl", ...)  -- ideavim: GotoRelated  (NOTE: LazyVim default = Git Log)

-- ----------------------------------------------------------------------------
-- Navigate -> windows/dialogs
-- ----------------------------------------------------------------------------
-- LazyVim default <leader>m = (unused prefix). ideavim: FileStructurePopup.
map("n", "<leader>m", function()
  Snacks.picker.lsp_symbols()
end, { desc = "File structure" })
-- LazyVim default <leader>u* = UI-toggle prefix (uf format, ur redraw, ud diagnostics...).
-- Overridden: ideavim FindUsages.
map("n", "<leader>u", vim.lsp.buf.references, { desc = "Find usages" })

-- ----------------------------------------------------------------------------
-- <leader>s : Show (hierarchies / structure / diff)   (ideavimrc)
-- LazyVim default <leader>s* = search prefix (only present with snacks_picker
--   extra, which is NOT enabled here). Safe to reuse.
-- ----------------------------------------------------------------------------
map("n", "<leader>sh", function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = "Call hierarchy" })
map("n", "<leader>st", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Type hierarchy" })
map("n", "<leader>ss", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Structure view" })
map("n", "<leader>sd", function()
  Snacks.picker.git_diff()
end, { desc = "Show diff" })

-- ----------------------------------------------------------------------------
-- Code / refactor
-- ----------------------------------------------------------------------------
-- ideavim <leader>f = ReformatCode + OptimizeImports.
-- LazyVim default: format is <leader>cf; <leader>f* is find prefix (ff, fr, fn...).
map({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = false, lsp_format = "fallback" })
  -- organize imports via LSP code action (jdtls / ts / etc.)
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" }, diagnostics = {} },
    apply = true,
  })
end, { desc = "Format code and organize imports" })

-- LazyVim default <leader>rr = (unused). ideavim: RenameElement.
map("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename element" })

-- ----------------------------------------------------------------------------
-- Project tree   (ideavim: NERDTreeFind)
-- LazyVim default <leader>t = (unused prefix); explorer is <leader>e.
-- LazyVim default <leader>ft/fT = terminal.
-- ----------------------------------------------------------------------------
map("n", "<leader>t", function()
  Snacks.explorer.reveal()
end, { desc = "Goto project window" })

-- ----------------------------------------------------------------------------
-- Move statements up/down   (ideavim: MoveStatement, <C-Up>/<C-Down>)
-- LazyVim default <C-Up>/<C-Down> = resize window height (kept for reference).
-- LazyVim also provides <A-j>/<A-k> for move (kept).
-- ----------------------------------------------------------------------------
map("n", "<C-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
map("n", "<C-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
map("v", "<C-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move lines up" })
map("v", "<C-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move lines down" })

-- ----------------------------------------------------------------------------
-- Unimpaired-style navigation   (ideavimrc [x / ]x)
-- Mapped to nearest native targets.
-- ----------------------------------------------------------------------------
map("n", "[<leader>", "<C-o>", { desc = "Navigate back" })
map("n", "]<leader>", "<C-i>", { desc = "Navigate forward" })
-- [q/]q quickfix, [d/]d diagnostics, [h/]h git hunks are LazyVim/gitsigns defaults (kept).
-- ideavim [f/]f = prev/next error -> LazyVim default [e/]e (kept). [f/]f stay
-- LazyVim's treesitter function jumps (buffer-local, so a global map never fires).
-- ideavim [m/]m = method up/down:
map("n", "[m", "[m", { desc = "Method up" })
map("n", "]m", "]m", { desc = "Method down" })

-- ----------------------------------------------------------------------------
-- Git   (ideavim: <leader>Gd Compare.SameVersion)
-- ----------------------------------------------------------------------------
map("n", "<leader>Gd", function()
  require("gitsigns").diffthis()
end, { desc = "Git diff" })

-- ----------------------------------------------------------------------------
-- Reselect visual selection after indenting   (kept; also LazyVim default)
-- ----------------------------------------------------------------------------
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ----------------------------------------------------------------------------
-- which-key group labels (mirror ideavim whichkeyrc)
-- ----------------------------------------------------------------------------
local ok_wk, wk = pcall(require, "which-key")
if ok_wk then
  wk.add({
    { "<leader>o", group = "Search" },
    { "<leader>g", group = "Goto" },
    { "<leader>s", group = "Show" },
    { "<leader>r", group = "Refactor" },
  })
end
