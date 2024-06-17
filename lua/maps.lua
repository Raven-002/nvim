-- --- Settings ---------------------------------------------------------------
-- Map leader key to space.
vim.g.mapleader = " "


-- --- Functions --------------------------------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- --- General ----------------------------------------------------------------
-- Clearing highlights after searching word in file.
map("n", "<Leader>h", ":noh<CR>")

-- Remove unnecessary white spaces.
map("n", "<Leader>rs", ":%s/ \\+$//<CR>")

-- Split navigations.
map("n", "<A-j>", "<C-w><C-j>")
map("n", "<A-k>", "<C-w><C-k>")
map("n", "<A-l>", "<C-w><C-l>")
map("n", "<A-h>", "<C-w><C-h>")

-- Set j and k to not skip lines.
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")


-- --- NvimTree ---------------------------------------------------------------
map('n', '<leader>e', ':NvimTreeToggle<CR>')


-- --- Telescope --------------------------------------------------------------
map("n", "<Leader>fw", ":Telescope live_grep<CR>")
map("n", "<Leader>gt", ":Telescope git_status<CR>")
-- map("n", "<Leader>cm", ":Telescope git_commits<CR>")
map("n", "<Leader>ff", ":Telescope find_files<CR>")
-- map("n", "<Leader>fp", ":Telescope media_files<CR>")
map("n", "<Leader>fb", ":Telescope buffers<CR>")
map("n", "<Leader>fh", ":Telescope help_tags<CR>")
map("n", "<Leader>fo", ":Telescope oldfiles<CR>")
map("n", "<Leader>th", ":Telescope colorscheme<CR>")
map("n", "<Leader>ss", ":Telescope spell_suggest<CR>")
map("n", "<Leader>fc", ":Telescope grep_string<CR>")
map("n", "<Leader>tt", ":Telescope<CR>")


-- --- Buffers ----------------------------------------------------------------
-- Buffer resizing.
map("n", "<S-h>", ":call ResizeLeft(3)<CR><Esc>")
map("n", "<S-l>", ":call ResizeRight(3)<CR><Esc>")
map("n", "<S-k>", ":call ResizeUp(1)<CR><Esc>")
map("n", "<S-j>", ":call ResizeDown(1)<CR><Esc>")

-- Buffer switching.
map("n", "<A-[>", ":BufferLineCyclePrev<CR>")
map("n", "<A-]>", ":BufferLineCycleNext<CR>")

-- Buffer opening
map("n", "<Leader>bb", ":BufferLinePick<CR>")

-- Buffer closing.
map("n", "<Leader>bc", ":BufferLinePickClose<CR>")

-- Buffer moving.
map("n", "<Leader>bl", ":BufferLineMoveNext<CR>")
map("n", "<Leader>bh", "::BufferLineMovePrev<CR>")


-- --- Lsp --------------------------------------------------------------------
-- Native
map("n", "<Leader>,", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<Leader>;", ":lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<Leader>a", ":lua vim.lsp.buf.code_action()<CR>")
-- map("n", "<Leader>gd", ":lua vim.lsp.buf.definition()<CR>")
map("n", "<Leader>k", ":lua vim.lsp.buf.hover()<CR>")
map("n", "<Leader>m", ":lua vim.lsp.buf.rename()<CR>")
-- map("n", "<Leader>r", ":lua vim.lsp.buf.references()<CR>")

-- Telescope
map("n", "<Leader>tr", ":Telescope lsp_document_symbols<CR>")
map("n", "<Leader>gd", ":Telescope lsp_definitions<CR>")
map("n", "<Leader>r", ":Telescope lsp_references<CR>")

-- Disabled
--map("n", "<Leader>f", ":lua vim.lsp.buf.formatting()<CR>")
--map("n", "<Leader>s", ":lua vim.lsp.buf.document_symbol()<CR>")


-- --- ToggleTerm -------------------------------------------------------------
map("n", "<C-t>", ":ToggleTerm<CR>")
map("t", "<C-t>", "<C-\\><C-n>:ToggleTerm<CR>")
map("n", "v:count1 <C-t>", ":v:count1" .. "\"ToggleTerm\"<CR>")
map("v", "v:count1 <C-t>", ":v:count1" .. "\"ToggleTerm\"<CR>")
function _G.set_terminal_keymaps()
  map("t", "<esc>", "<C-\\><C-n>")
  map("t", "<C-q>", "<esc>")

  map("t", "<A-h>", "<c-\\><c-n><c-w>h")
  map("t", "<A-j>", "<c-\\><c-n><c-w>j")
  map("t", "<A-k>", "<c-\\><c-n><c-w>k")
  map("t", "<A-l>", "<c-\\><c-n><c-w>l")

  -- map("t", "<S-h>", "<c-\\><C-n>:call ResizeLeft(3)<CR>")
  -- map("t", "<S-j>", "<c-\\><C-n>:call ResizeDown(1)<CR>")
  -- map("t", "<S-k>", "<c-\\><C-n>:call ResizeUp(1)<CR>")
  -- map("t", "<S-l>", "<c-\\><C-n>:call ResizeRight(3)<CR>")
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")


-- --- Comment Toggle ---------------------------------------------------------
map("n", "<C-/>", ":CommentToggle<CR>")
map("v", "<C-/>", ":'<,'>CommentToggle<CR>")


-- --- Debug ------------------------------------------------------------------
vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)
