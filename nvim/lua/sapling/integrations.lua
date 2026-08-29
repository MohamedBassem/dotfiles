local M = {}

local core = require("sapling.core")

-- Let mini.diff own Sapling buffers while gitsigns continues to handle Git.
function M.gitsigns_on_attach(bufnr)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file ~= "" and core.repo(vim.fs.dirname(file)) then
		return false
	end
end

function M.setup_mini_diff()
	local editor = require("sapling.editor")
	require("mini.diff").setup({
		source = editor.source,
		view = {
			style = "sign",
			signs = { add = "▎", change = "▎", delete = "▎" },
		},
	})
	editor.setup_blame()
end

M.diffview_opts = {
	hg_cmd = { "sl" },
	preferred_adapter = "hg",
}

return M
