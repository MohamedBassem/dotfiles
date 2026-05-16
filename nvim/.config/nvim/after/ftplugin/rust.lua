
local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
  end,
})

vim.keymap.set("n", "<leader>dR", function()
  vim.cmd.RustLsp("relatedDiagnostics")
end, { buffer = bufnr, desc = "Rust: Related diagnostics" })

vim.keymap.set("n", "<leader>dd", function()
  vim.cmd.RustLsp({ "renderDiagnostic", "current" })
end, { buffer = bufnr, desc = "Rust: Render current diagnostic" })

vim.keymap.set({ "n", "x", "o" }, "]]", "]m", { buffer = bufnr, desc = "Next function" })
vim.keymap.set({ "n", "x", "o" }, "[[", "[m", { buffer = bufnr, desc = "Function top" })

vim.api.nvim_buf_create_user_command(bufnr, "OpenCargo", function()
  vim.cmd.RustLsp('openCargo')
end, {})
