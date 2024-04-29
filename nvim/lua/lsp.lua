-- Setup lsp-zero
local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	-- lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })

	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

	-- Find references for the word under your cursor.
	map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- Opens a popup that displays documentation about the word under your cursor
	--  See `:help K` for why this keymap.
	map("K", vim.lsp.buf.hover, "Hover Documentation")

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header.
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- Jump to diagnostic
	map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
	map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
	map("gl", vim.diagnostic.open_float, "Open diagnostic float")

	-- Signature Help
	map("gs", vim.lsp.buf.signature_help, "Signature [H]elp")

	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })

	client.server_capabilities.semanticTokensProvider = nil

	require("lsp-inlayhints").on_attach(client, bufnr)
end)
-- (Optional) Configure lua language server for neovim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

-- Enable inly hints in tsserver
-- require("lspconfig").tsserver.setup({
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 		javascript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = false,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 	},
-- })

lsp.set_sign_icons({
	error = "✘",
	warn = "▲",
	hint = "⚑",
	info = "»",
})

lsp.set_server_config({
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
})

lsp.setup()

-- Setup auto completion
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	preselect = "None",
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		-- Ctrl+Space to trigger completion menu
		["<C-l>"] = cmp.mapping.complete(),

		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			mode = "symbol_text", -- show only symbol annotations
			preset = "codicons",
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			show_labelDetails = true,
			menu = {
				nvim_lsp = "[LSP] ",
				buffer = "[Buffer] ",
				path = "[Path] ",
			},
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "crates" },
		{ name = "nvim_lsp_signature_help" },
	},
})
