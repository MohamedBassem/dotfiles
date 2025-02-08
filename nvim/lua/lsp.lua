vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local bufnr = event.buf

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")

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

		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end

		-- Enable inlay hints if it's supported by the LSP
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end
	end
})

vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '󰌵',
		},
	},
})

local lsp_capabilities = vim.tbl_deep_extend(
	'force',
	require('blink.cmp').get_lsp_capabilities(),
	{
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true
			},
		},
	}
)

local default_setup = function(server)
	require('lspconfig')[server].setup({
		capabilities = lsp_capabilities,
	})
end

require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		default_setup,
	},
})
