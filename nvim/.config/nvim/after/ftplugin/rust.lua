
local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    require("conform").format({ bufnr = bufnr, async = false, timeout_ms = 3000 })
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

vim.keymap.set("n", "<leader>io", function()
  local diags = vim.tbl_filter(function(d)
    return d.code == "unused_imports"
  end, vim.diagnostic.get(bufnr))

  if #diags == 0 then
    vim.notify("No unused imports", vim.log.levels.INFO)
    return
  end

  local saved = vim.api.nvim_win_get_cursor(0)
  local d = diags[1]
  vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col })

  vim.lsp.buf.code_action({
    apply = true,
    filter = function(a)
      return a.title == "Remove all unused imports"
    end,
  })

  vim.defer_fn(function()
    pcall(vim.api.nvim_win_set_cursor, 0, saved)
  end, 200)
end, { buffer = bufnr, desc = "Rust: Remove all unused imports" })
