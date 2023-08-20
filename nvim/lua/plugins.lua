return {
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").load()
		end,
	},
	"nvim-treesitter/nvim-treesitter",
	"nvim-tree/nvim-web-devicons",
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				sort_by = "case_sensitive",
				filters = {
					dotfiles = true,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			-- require("telescope").setup({})

			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			-- require("telescope").load_extension("ui-select")
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				extensions = { "nvim-tree" },
			})
		end,
	},
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
		},
	},

	{ "onsails/lspkind.nvim" },

	-- save my last cursor position
	{
		"ethanholz/nvim-lastplace",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"rust-analyzer",
				"tsserver",
				"eslint",
			},
		},
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
		},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.shfmt,
				},
			}
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	"simrat39/rust-tools.nvim",
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup()
		end,
	},
	{
		"rcarriga/nvim-notify",
	},
	{
		"mhinz/vim-startify",
	},
}
