return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "frappe",
				integrations = {
					fidget = true,
					mason = true,
					navic = true,
					lsp_trouble = true,
					which_key = true,
					blink_cmp = true,
				},
			})
			-- Make namespaces white (specially in cpp) to easily distinguish
			-- the actual type from its namespace.
			--  vim.api.nvim_set_hl(0, "@namespace", { link = "@variable" })
			--  vim.api.nvim_set_hl(0, "@type.qualifier", { link = "@keyword" })
			--  vim.api.nvim_set_hl(0, "@type.builtin", { link = "@keyword" })
			--  vim.api.nvim_set_hl(0, "@constructor", { link = "@function.call" })
			--  vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })

			vim.cmd.colorscheme("catppuccin")
		end,
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
				indent = {
					enable = true,
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
			local trouble = require("trouble.sources.telescope")

			require("telescope").setup({
				defaults = {
					-- layout_strategy = "vertical",
					mappings = {
						i = {
							-- ["<esc>"] = actions.close,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							-- After using live grep, use that to filter the search results
							["<c-f>"] = actions.to_fuzzy_refine,

							-- Send results to trouble menu
							["<c-t>"] = trouble.open_with_trouble,

							["<c-o>"] = function(prompt_bufnr)
								local entry = require("telescope.actions.state").get_selected_entry();
								require("telescope.actions").close(prompt_bufnr);
								vim.cmd("Oil --float " .. vim.fn.fnamemodify(entry.path, ':h'));
							end,
						},
						n = {
							-- Send results to trouble menu
							["<c-t>"] = trouble.open_with_trouble,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--no-require-git" },
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
						ctxlen = 8,
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
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				use_diagnostic_signs = true,
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
		config = function()
			require("fidget").setup({
				notification = {
					-- override_vim_notify = true,
				},
			})
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
					theme = "catppuccin",
				},
				extensions = { "trouble" },
				tabline = {
					lualine_c = {
						{ require("utils").harpoon_files },
					},
				},
				sections = {
					lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_workspace_diagnostic" } } },
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
						{
							"navic",
							color_correction = "static",
							padding = { left = 1, right = 0 },
							navic_opts = {
								depth_limit = 4,
								click = true,
							},
						},
					},
				},
			})
		end,
	},
	-- {
	-- 	'nvim-treesitter/nvim-treesitter-context',
	-- 	config = function()
	-- 		require'treesitter-context'.setup{
	-- 			-- max_lines = 1,
	-- 			multiline_threshold = 1,
	-- 			trim_scope = 'inner'
	-- 		};
	-- 	end
	-- },
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
				"tailwindcss-language-server",
				"eslint-lsp",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- LSP Support
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
	},
	{
		'saghen/blink.cmp',
		version = '*',
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				['<S-Tab>'] = { 'select_prev', 'fallback' },
				['<Tab>'] = { 'select_next', 'fallback' },
				["<C-l>"] = { 'show', 'fallback' },
				["<CR>"] = { 'accept', 'fallback' },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = false,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
				cmdline = {},
			},
			signature = {
				enabled = true,
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind" }
						},
					},
				},
				list = { selection = 'auto_insert' },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},
		},
		opts_extend = { "sources.default" },
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
					-- Lua
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.shfmt,

					-- Typescript
					-- nls.builtins.diagnostics.tsc,
					nls.builtins.formatting.prettier,
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
				lsp = {
					auto_attach = true,
				},
			})
		end,
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
		enabled = not require("utils").meta_mode(),
	},
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
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				delay = 200,
				large_file_cutoff = 2000,
				large_file_overrides = {
					providers = { "lsp" },
				},
			})
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
	{ 'echasnovski/mini.ai', version = false, opts = {} },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		config = function()
			require("harpoon").setup({})
			-- require("telescope").load_extension("harpoon")
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
						target = {
							{
								target = "/%1/%2.cpp",
								context = "cpp",
							},
							{
								target = "/%1/%2-inl.h",
								context = "inline_header",
							},
						},
					},
					{
						pattern = "/(.*)/(.*).cpp$",
						target = {
							{
								target = "/%1/%2.h",
								context = "header",
							},
							{
								target = "/%1/%2-inl.h",
								context = "inline_header",
							},
						},
					},
					{
						pattern = "/(.*)/(.*)-inl.h$",
						target = {
							{
								target = "/%1/%2.cpp",
								context = "cpp",
							},
							{
								target = "/%1/%2.h",
								context = "header",
							},
						},
					},
				},
				-- Don't create the file if it doesn't exist
				showMissingFiles = false,
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "LazyVim",            words = { "LazyVim" } },
				{ path = "snacks.nvim",        words = { "Snacks" } },
				{ path = "lazy.nvim",          words = { "LazyVim" } },
			},
		},
	},
	{
		'MeanderingProgrammer/markdown.nvim',
		main = "render-markdown",
		opts = {},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("ufo").setup()
		end,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup({
				popup = {
					autofocus = true,
				},
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
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
				["<ESC>"] = "actions.close",
				["?"] = "actions.show_help",
				["g?"] = false, -- The default help
				["<C-c>"] = false, -- The default close
			},
			skip_confirm_for_simple_edits = true,
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		'MagicDuck/grug-far.nvim',
		config = function()
			require('grug-far').setup({
				debounceMs = 100,
			});
		end
	},
	{
		"dstein64/nvim-scrollview",
		config = function()
			require("scrollview").setup({
				-- Show even if the buffer fits the screen
				always_show = true,
				-- Show on all visibile buffers
				current_only = false,
				include_end_region = true,

				-- Transparency of the scrollbar
				winblend_gui = 50,

				-- Customizing the different symbols
				diagnostics_warn_symbol = '│',
				diagnostics_hint_symbol = '│',
				diagnostics_info_symbol = '│',
				diagnostics_error_symbol = '│',
				search_symbol = '│',
			})
		end,
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	enabled = not require("utils").meta_mode(),
	-- 	opts = {
	-- 		suggestion = {
	-- 			-- Enable or disable suggestions
	-- 			enabled = true,
	-- 			-- Automatically accept suggestions
	-- 			auto_trigger = true,
	-- 			keymap = {
	-- 				accept = "<C-J>",
	-- 			},
	-- 		}
	-- 	},
	-- },
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	enabled = not require("utils").meta_mode(),
	-- 	branch = "canary",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
	-- 		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	-- 	},
	-- 	build = "make tiktoken", -- Only on MacOS or Linux
	-- 	opts = {
	-- 		debug = true,        -- Enable debugging
	-- 		-- See Configuration section for rest
	-- 	},
	-- 	-- See Commands section for default commands if you want to lazy load on them
	-- },
	{
		"supermaven-inc/supermaven-nvim",
		enabled = not require("utils").meta_mode(),
		config = function()
			require("supermaven-nvim").setup({
				disable_keymaps = true,
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "VonHeikemen/lsp-zero.nvim" },
		opts = {
			on_attach = function(client)
				-- Formatting is handled by none-ls
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			settings = {
				tsserver_file_preferences = {
					-- includeInlayParameterNameHints = "all",
					-- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					-- includeInlayFunctionParameterTypeHints = true,
					-- includeInlayVariableTypeHints = true,
					-- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					-- includeInlayPropertyDeclarationTypeHints = true,
					-- includeInlayFunctionLikeReturnTypeHints = true,
					-- includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {}
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = {
				enabled = true,
				notify = true,
				size = 0.5 * 1024 * 1024, -- 500 KB
			},
			zen = {
				enabled = true,
				toggles = {
					dim = false,
					git_signs = true,
					diagnostics = true,
					inlay_hints = true,
				},
				zoom = {
					win = {
						width = 0.8,
					}
				}
			},
			indent = {
				enabled = true,
				animate = {
					enabled = false,
				}
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			dashboard = {
				enabled = true,
				row = 3,
				col = 3,
				width = 120,
				formats = {
					key = function(item)
						return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
					end,
				},
				sections = {
					{ section = "header",       align = "left" },
					{ title = "MRU ",           file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
					{ section = "recent_files", cwd = true,                           limit = 8,  padding = 1 },
					{ title = "MRU",            padding = 1 },
					{ section = "recent_files", limit = 8,                            padding = 1 },
					-- { title = "Bookmarks", padding = 1 },
					-- { section = "keys" },
				},
			},
			-- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
			quickfile = { enabled = true },
			-- scroll = { enabled = true },
			gitbrowse = { enabled = true },
			statuscolumn = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
			lazygit = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true } -- Wrap notifications
				},
			},
		},
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
