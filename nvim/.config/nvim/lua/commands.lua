-- Opens the current file in the browser
vim.api.nvim_create_user_command("OpenInGithub", function()
  vim.cmd("OpenInGHFileLines")
end, {})

-- Copy's the current line's github link to the clipboard
vim.api.nvim_create_user_command("GetGithubLink", function()
  vim.cmd("OpenInGHFileLines+")
end, {})
