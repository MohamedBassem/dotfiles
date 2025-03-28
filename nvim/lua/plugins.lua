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
		"nvim-tree/nvim-web-devicons",
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
	{
		'nvim-treesitter/nvim-treesitter-context',
		config = function()
			require'treesitter-context'.setup{
				-- max_lines = 1,
				multiline_threshold = 1,
				trim_scope = 'inner'
			};
		end
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
				"tailwindcss-language-server",
				"eslint-lsp",
				"biome",
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
			},
			cmdline = {
				enabled = false,
				sources = {},
			},
			signature = {
				enabled = true,
			},
			completion = {
				accept = {
					-- experimental auto-brackets support
					auto_brackets = {
						enabled = false,
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
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = vim.g.ai_cmp,
				},
			},
            fuzzy = {
                prebuilt_binaries = {
                    -- only set a proxy in meta mode
                    extra_curl_args = require("utils").meta_mode() and { "--proxy", "http://fwdproxy:8080" } or {},
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
	--    {
	-- 	'EvWilson/spelunk.nvim',
	-- 	dependencies = {
	-- 		'nvim-lua/plenary.nvim',         -- For window drawing utilities
	-- 		'nvim-telescope/telescope.nvim', -- Optional: for fuzzy search capabilities
	-- 	},
	-- 	config = function()
	-- 		require('spelunk').setup({
	-- 			enable_persist = true
	-- 		})
	-- 	end
	-- },
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
				["cp"] = "actions.copy_entry_path",
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
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
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
			words = {
				enabled = true,
				debounce = 100,
			},
			input = {
				enabled = true,
			},
			lazygit = { enabled = true },
			picker = { enabled = true },
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
