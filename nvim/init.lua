-- Config inspired from:
--   - https://github.com/AhmedSoliman/dotfiles
--   - https://github.com/fatih/dotfiles
--   - https://github.com/LazyVim/LazyVim
--   - https://github.com/nvim-lua/kickstart.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.g.maplocalleader = ","

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
		concurrency = 5,
	}
)

require("options")
require("keymaps")
require("autocmds")
require("lsp")
if require("utils").meta_mode() then
	require("custom_meta")
end
