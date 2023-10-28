return {
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").load()
			-- Make namespaces white (specially in cpp) to easily distinguish
			-- the actual type from its namespace.
			vim.api.nvim_set_hl(0, "@namespace", { link = "@variable" })
			vim.api.nvim_set_hl(0, "@type.qualifier", { link = "@keyword" })
			vim.api.nvim_set_hl(0, "@type.builtin", { link = "@keyword" })
			vim.api.nvim_set_hl(0, "@constructor", { link = "@function.call" })
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		end,
		priority = 99,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"rust",
					"python",
					"javascript",
					"typescript",
					"dockerfile",
					"go",
					"java",
					"json",
					"markdown",
					"toml",
					"yaml",
					"html",
					"css",
					"lua",
					"thrift",
					"starlark",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = nil,
						node_decremental = "<BS>",
					},
				},
				textobjects = {
					enable = true,
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							-- After using live grep, use that to filter the search results
							["<c-f>"] = actions.to_fuzzy_refine,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					["ui-select"] = {},
					undo = {
						diff_context_lines = 8,
						mappings = {
							-- Those are the defaults, keeping them here just as a reminder
							i = {
								["<cr>"] = require("telescope-undo.actions").restore,
							},
						},
					},
				},
			})
			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("fzf")

			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")

			-- Undo tree
			require("telescope").load_extension("undo")
		end,
		dependencies = { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" },
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {},
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "onedark",
				},
				extensions = { "nvim-tree" },
				sections = {
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
						{
							function()
								return require("nvim-navic").get_location()
							end,
						},
					},
				},
			})
		end,
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- 	config = function()
	-- 		require("bufferline").setup({})
	-- 	end,
	-- },

	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
		},
	},

	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init({})
		end,
	},

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
		"lvimuser/lsp-inlayhints.nvim",
		config = function()
			require("lsp-inlayhints").setup({
				enabled_at_startup = true,
				inlay_hints = {
					parameter_hints = {
						show = false,
					},
				},
			})
		end,
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
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(
					".null-ls-root",
					".neoconf.json",
					"Makefile",
					".git",
					".hg"
				),
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
	{
		"simrat39/rust-tools.nvim",
	},
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup()
		end,
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"folke/flash.nvim",
		lazy = false,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		-- We'll use vim-signify in meta as gitsigns doesn't support mercurial
		enabled = not require("utils").meta_mode(),
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	},
	{
		"mhinz/vim-signify",
		enabled = require("utils").meta_mode(),
		config = function()
			vim.cmd("highlight link SignifySignAdd GitSignsAdd")
			vim.cmd("highlight link SignifySignChange GitSignsChange")
			vim.cmd("highlight link SignifySignChangeDelete GitSignsChange")
			vim.cmd("highlight link SignifySignDelete GitSignsDelete")
			vim.cmd("highlight link SignifySignDeleteFirstLine GitSignsDelete")
			vim.g.signify_sign_change = "│"
			vim.g.signify_sign_add = "│"
			vim.g.signify_sign_change_delete = "_"
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "▏",
				tab_char = "▏",
				smart_indent_cap = false,
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	-- Navic provide the breadcrumbs in lualine
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("nvim-navic").setup({
				highlight = true,
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
			})
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 0.75, -- 75% width
			},
		},
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	{
		-- Show the diff of the code action before applying it
		"aznhe21/actions-preview.nvim",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({})
		end,
	},
	{
		"rmagatti/goto-preview",
		config = function()
			require("goto-preview").setup({
				default_mappings = true,
			})
		end,
	},
	{
		"echasnovski/mini.bufremove",
		version = false,
		config = function()
			require("mini.bufremove").setup()
		end,
	},
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				menu = {
					width = math.floor(vim.api.nvim_win_get_width(0) * 2 / 3),
				},
				tabline = true,
			})
			require("telescope").load_extension("harpoon")
			vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
			vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
			vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
			vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")
		end,
	},
	{
		-- For switching between .h and .cpp files
		"rgroli/other.nvim",
		config = function()
			require("other-nvim").setup({
				mappings = {
					{
						pattern = "/(.*)/(.*).h$",
						target = "/%1/%2.cpp",
						context = "cpp",
					},
					{
						pattern = "/(.*)/(.*).cpp$",
						target = "/%1/%2.h",
						context = "header",
					},
				},
				-- Don't create the file if it doesn't exist
				showMissingFiles = false,
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"folke/neodev.nvim",
		opts = {},
	},
	{
		"LunarVim/bigfile.nvim",
		config = function()
			require("bigfile").setup({
				filesize = 0.5, -- In MiB
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup()
		end,
	},
	{
		"natecraddock/workspaces.nvim",
		config = function()
			require("workspaces").setup({
				hooks = {
					open = function()
						vim.cmd("%bd")
						require("persistence").load()
					end,
					open_pre = function()
						require("persistence").save()
					end,
				},
			})
			require("telescope").load_extension("workspaces")
		end,
	},
	-- Only needed when customizing the theme colors.
	-- {
	-- 	'nvim-treesitter/playground',
	-- 	config = function()
	-- 		require "nvim-treesitter.configs".setup{};
	-- 	end,
	-- },
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
			},
			keymaps = {
				["q"] = "actions.close",
				["?"] = "actions.show_help",
				["g?"] = false, -- The default help
				["<C-c>"] = false, -- The default close
			},
			skip_confirm_for_simple_edits = true,
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		dir = "/usr/share/fb-editor-support/nvim",
		-- dir = "~/fbsource/fbcode/editor_support/nvim",
		enabled = require("utils").meta_mode(),
		name = "meta.nvim",
		opts = {
			lsp = {
				vscode_extensions = {
					shim_show_status_to_progress_handler = true,
				},
			},
		},
	},
}
