local M = {}

function M.meta_mode()
	return vim.fn.isdirectory("/usr/share/fb-editor-support/nvim") == 1
end

return M
