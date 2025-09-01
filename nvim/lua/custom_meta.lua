local meta = require("meta")


require("meta.hg").setup({
    -- line_blame = {
    --     enable = true,
    --     highlight = "GitSignsCurrentLineBlame",
    --     prefix = string.rep(" ", 12),
    --     debounce_ms = 1000,
    -- },
    picker = "snacks",
    signs = {
        add = {
            char = "│",
            hl = "GitSignsAdd",
        },
        delete = {
            char = "_",
            hl = "GitSignsDelete",
        },
    },
})

local in_meta_project = require("meta.util").arc.get_project_root(vim.loop.cwd()) ~= nil

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

-- Setup metalsp
require("meta.lsp")
require('meta.metamate').init({
  filetypes = {"python", "rust", "cpp", "configerator"}
})
local servers = {
    "linttool@meta",
    "fb-pyright-ls@meta",
    "thriftlsp@meta",
    "buck2@meta",
    "pyre@meta",
    "rust-analyzer@meta",
    "cppls@meta",
    "thriftlsp@meta",
    "hhvm",
}
for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup {
        capabilities = lsp_capabilities,
    }
end

-- Treesitter fwdproxy
require("nvim-treesitter.install").command_extra_args = {
    curl = { "--proxy", "http://fwdproxy:8080" },
}


-- Null ls setup
-- Setup diagnostics and formatters.
if in_meta_project then
    local null_ls = require("null-ls")
    null_ls.register({
      meta.null_ls.diagnostics.arclint,
      meta.null_ls.formatting.arclint,
      meta.null_ls.formatting.autodeps,
      meta.null_ls.diagnostics.rust_clippy,
    })
end


-- When in meta project, use null-ls for formatting
if in_meta_project then
    -- vim.keymap.set("n", "<C-f>", ":LspZeroFormat! null-ls<CR>")
    --vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format({ async = true }) end)
end

-- When in meta project, accept metamate suggestion with <C-j>
if in_meta_project then
    vim.keymap.set("i", "<C-j>", require("meta.metamate").accept)
end

-- Meta specific c++ style guide
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cpp" },
	callback = function()
		vim.opt_local.shiftwidth = 2 -- four spaces per indent
		vim.opt_local.expandtab = true -- don't use tabs
		vim.opt_local.tabstop = 2 -- number of spaces per tab in display
	end,
})


vim.api.nvim_create_user_command("XStreamFiles", function()
    Snacks.picker.files({
        dirs = {
            "~/fbcode/xstream/",
        }
    })
end, {})
