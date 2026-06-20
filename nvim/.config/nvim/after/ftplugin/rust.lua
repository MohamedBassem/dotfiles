
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
  local saved = vim.api.nvim_win_get_cursor(0)
  local max_iterations = 20

  local function remove_unused(iteration)
    local diags = vim.tbl_filter(function(d)
      return d.code == "unused_imports"
    end, vim.diagnostic.get(bufnr))

    if #diags == 0 then
      if iteration == 1 then
        vim.notify("No unused imports", vim.log.levels.INFO)
      end
      pcall(vim.api.nvim_win_set_cursor, 0, saved)
      return
    end

    if iteration > max_iterations then
      vim.notify("Stopped removing unused imports after " .. max_iterations .. " iterations", vim.log.levels.WARN)
      pcall(vim.api.nvim_win_set_cursor, 0, saved)
      return
    end

    local d = diags[1]
    vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col })

    vim.lsp.buf.code_action({
      apply = true,
      filter = function(a)
        return a.title == "Remove all unused imports"
      end,
    })

    vim.defer_fn(function()
      remove_unused(iteration + 1)
    end, 200)
  end

  remove_unused(1)
end, { buffer = bufnr, desc = "Rust: Remove all unused imports" })
