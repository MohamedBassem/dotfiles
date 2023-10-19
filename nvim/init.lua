-- Config inspired from:
--   - https://github.com/AhmedSoliman/dotfiles
--   - https://github.com/fatih/dotfiles
--   - https://github.com/LazyVim/LazyVim
--   - https://github.com/nvim-lua/kickstart.nvim

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

require("lazy").setup(
	"plugins",
	{
		performance = {
		  rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
			  "gzip",
			  -- "matchit",
			  -- "matchparen",
			  -- "netrwPlugin",
			  "tarPlugin",
			  "tohtml",
			  "tutor",
			  "zipPlugin",
			},
		  },
		},
	}
)

require("options")
require("keymaps")
require("autocmds")
require("lsp")
if require("utils").meta_mode() then
	require("custom_meta")
end
