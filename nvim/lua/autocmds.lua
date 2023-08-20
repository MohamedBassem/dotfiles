-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- automatically switch to insert mode when entering a Term buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
	group = vim.api.nvim_create_augroup("openTermInsert", {}),
	callback = function(args)
		-- we don't use vim.startswith() and look for test:// because of vim-test
		-- vim-test starts tests in a terminal, which we want to keep in normal mode
		if vim.endswith(vim.api.nvim_buf_get_name(args.buf), "zsh") then
			vim.cmd("startinsert")
		end
	end,
})

-- don't show line number in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
	command = [[setlocal nonumber norelativenumber]],
})

-- Disable automatically adding comments on new lines
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNewFile" }, {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	command = [[lua vim.lsp.buf.format()]],
})

-- Open Nvim-tree on startup
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		require("nvim-tree.api").tree.toggle({ focus = false })
	end,
})
