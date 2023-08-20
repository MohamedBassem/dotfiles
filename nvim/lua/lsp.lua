-- Setup lsp-zero
local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp.default_keymaps({ buffer = bufnr })
end)
-- (Optional) Configure lua language server for neovim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()


-- Setup auto completion
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	completion = {
		completeopt = "menu,menuone,noselect",
	},
	mapping = {
		-- `Enter` key to confirm completion
		["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
})
