-- Config inspired from:
--   - https://github.com/AhmedSoliman/dotfiles
--   - https://github.com/fatih/dotfiles
--   - https://github.com/LazyVim/LazyVim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader = ","

require("lazy").setup("plugins")

require("options")
require("keymaps")
require("autocmds")
require("lsp")
require("editor")
