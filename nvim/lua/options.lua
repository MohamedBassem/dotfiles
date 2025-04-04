-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.showmode = false -- Don't show mode since we have a statusline
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
vim.opt.completeopt = "menu,menuone,noselect" -- Autocomplete options

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of indent.
vim.opt.tabstop = 4 -- number of spaces a TAB counts for
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:~" -- Show trailing spaces and hide tab chars
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = false -- Don't wrap

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- relative in normal mode
vim.opt.relativenumber = true

-- Enable break indent
vim.opt.breakindent = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Tab complete for cmd mode should autocomplete the first result immediately.
vim.opt.wildmode = "full"

-- Refresh files edited on disk automatically
vim.opt.autoread = true

-- Fold configuration (copied from nvim-ufo)
vim.o.foldcolumn = '0' -- Disabling the fold column
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- lualine
vim.o.laststatus = 3 -- Make the status line global instead of per pane

-- Always show signcolumn
vim.opt.signcolumn = "yes"

-- Folding (requires nvim 0.11)
vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
