return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				integrations = {
					fidget = true,
					mason = true,
					lsp_trouble = true,
					which_key = true,
					blink_cmp = true,
					grug_far = true,
					harpoon = true,
					snacks = {
						enabled = true,
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"bash",
				"c",
				"cpp",
				"rust",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"dockerfile",
				"go",
				"java",
				"json",
				"markdown",
				"markdown_inline",
				"toml",
				"yaml",
				"html",
				"tmux",
				"css",
				"lua",
				"thrift",
				"starlark",
				"hack",
			}
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
						return
					end
					if vim.treesitter.query.get(lang, "indents") then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
					if vim.treesitter.query.get(lang, "folds") then
						vim.wo.foldmethod = "expr"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
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
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		branch = "master",
		config = function()
			require("treesitter-context").setup({
				max_lines = 3,
				multiline_threshold = 2,
				trim_scope = "inner",
				mode = "topline",
			})
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
				"oxlint",
				"oxfmt",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- LSP Support
			{ "williamboman/mason.nvim" },
		},
	},
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<C-l>"] = { "show", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = false,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			cmdline = {
				enabled = true,
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
							{ "kind" },
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
				list = {
					selection = {
						-- When using Enter as the accept key, enabling preselect makes it hard to sometimes
						-- enter a new line. So for now, we're disabling it.
						preselect = false,
					},
				},
			},
			fuzzy = {
				prebuilt_binaries = {},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local function has_root_file(ctx, names)
				return vim.fs.find(names, { path = ctx.filename, upward = true })[1] ~= nil
			end

			local web_formatters = { "oxfmt", "prettier", stop_after_first = true }

			return {
				formatters_by_ft = {
					lua = { "stylua" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					zsh = { "shfmt" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = web_formatters,
					javascriptreact = web_formatters,
					typescript = web_formatters,
					typescriptreact = web_formatters,
					json = web_formatters,
					jsonc = web_formatters,
					css = web_formatters,
					html = web_formatters,
					yaml = web_formatters,
					markdown = web_formatters,
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
				formatters = {
					oxfmt = {
						condition = function(utils)
							return has_root_file(utils, { ".oxlintrc.json", "oxfmt.toml" })
						end,
					},
					prettier = {
						condition = function(utils)
							return has_root_file(utils, {
								".prettierrc",
								".prettierrc.json",
								".prettierrc.yaml",
								".prettierrc.yml",
								".prettierrc.js",
								".prettierrc.cjs",
								".prettierrc.mjs",
								".prettierrc.toml",
								"prettier.config.js",
								"prettier.config.cjs",
								"prettier.config.mjs",
							})
						end,
					},
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		config = function()
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
				callback = function(args)
					if vim.bo.modifiable then
						require("lint").try_lint()
					end
				end,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
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
			{
				"<CR>",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter({
						actions = {
							["<CR>"] = "next",
							["<BS>"] = "prev",
						},
					})
				end,
				desc = "Treesitter Incremental Selection",
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
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
	{ "echasnovski/mini.ai", version = false, opts = {} },
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
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
			},
		},
	},
	{
		"MeanderingProgrammer/markdown.nvim",
		main = "render-markdown",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
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
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({
				debounceMs = 100,
			})
		end,
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
				diagnostics_warn_symbol = "│",
				diagnostics_hint_symbol = "│",
				diagnostics_info_symbol = "│",
				diagnostics_error_symbol = "│",
				search_symbol = "│",
			})
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
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
		opts = {},
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
					},
				},
			},
			indent = {
				enabled = true,
				animate = {
					enabled = false,
				},
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
					{ section = "header", align = "left" },
					{ title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
					{ section = "recent_files", cwd = true, limit = 8, padding = 1 },
					{ title = "MRU", padding = 1 },
					{ section = "recent_files", limit = 8, padding = 1 },
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
			picker = {
				enabled = true,
				layout = {
					-- Use a wide layout on big screens, and a wider vertical
					-- (stacked) one once the window gets narrow.
					preset = function()
						return vim.o.columns >= 200 and "default" or "wide_vertical"
					end,
				},
				layouts = {
					-- Same as the built-in "vertical" preset, just wider.
					wide_vertical = {
						preset = "vertical",
						layout = { width = 0.9, height = 0.9 },
					},
				},
				sources = {
					files = {
						hidden = true,
					},
					commands = {
						confirm = function(picker, item)
							picker:close()
							if not (item and item.cmd) then
								return
							end

							local nargs = item.command and item.command.nargs
							if nargs == "0" then
								vim.schedule(function()
									vim.cmd(item.cmd)
								end)
							else
								vim.schedule(function()
									vim.api.nvim_input(":")
									vim.schedule(function()
										vim.fn.setcmdline(item.cmd .. " ")
									end)
								end)
							end
						end,
					},
				},
			},
			terminal = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
	},
	{
		"sindrets/diffview.nvim",
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup({
				lsp = {
					enabled = true,
					actions = true,
					completion = true,
					hover = true,
				},
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		-- To avoid being surprised by breaking changes,
		-- I recommend you set a version range
		version = "^9",
		-- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
		-- No need for lazy.nvim to lazy-load it.
		lazy = false,

		init = function()
			vim.g.rustaceanvim = {
				-- LSP configuration
				server = {
					settings = {
						-- rust-analyzer language server configuration
						["rust-analyzer"] = {
							assist = {
								importGranularity = "module",
								importPrefix = "by_self",
							},
							cargo = {
								loadOutDirsFromCheck = true,
								targetDir = true,
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
			}
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup {
				-- Your setup opts here (leave empty to use defaults)
			}
		end,
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
	},
}
