-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.number = true -- Show line numbers
vim.opt.showmatch = true -- Highlight matching parenthesis
vim.opt.splitright = true -- Split windows right to the current windows
vim.opt.splitbelow = true -- Split windows below to the current windows
vim.opt.autowrite = true -- Automatically save before :next, :make etc.
vim.opt.cursorline = true -- Enable highlighting of the current line

vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
vim.opt.swapfile = false -- Don't use swapfile
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not it begins with upper case
vim.opt.completeopt = "menuone,noselect" -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 4 -- number of spaces a TAB counts for
vim.opt.list = true 
vim.opt.listchars = "tab:>~" -- Show tabs as chars
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = false -- Don't wrap

-- show absolute numbers in insert mode, relative in normal mode
vim.opt.relativenumber = true
vim.cmd([[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]])

-- Tab complete for cmd mode should autocomplete the first result immediately.
vim.opt.wildmode = "full"

-- Refresh files edited on disk automatically
vim.opt.autoread = true
