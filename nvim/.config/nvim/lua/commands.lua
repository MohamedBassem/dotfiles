
-- Rust specific commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust"},
  callback = function(args)
    vim.api.nvim_buf_create_user_command(args.buf, "OpenCargo", function()
      vim.cmd.RustLsp('openCargo')
    end, {})
  end,
})
