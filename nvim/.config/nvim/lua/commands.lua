-- Wraps Snacks.gitbrowse to prefer "upstream", then "origin", when present.
-- Snacks has no option to pick a remote, so when it would prompt (multiple
-- remotes) we transparently auto-select the first preferred remote that
-- exists; otherwise behave as usual.
local preferred_remotes = { "upstream", "origin" }
local function gitbrowse(opts)
  local select = vim.ui.select
  vim.ui.select = function(items, select_opts, on_choice)
    vim.ui.select = select -- restore before doing anything else
    for _, name in ipairs(preferred_remotes) do
      for _, item in ipairs(items) do
        if item.name == name then
          return on_choice(item)
        end
      end
    end
    return select(items, select_opts, on_choice)
  end
  local ok, err = pcall(Snacks.gitbrowse, opts)
  vim.ui.select = select -- restore in case it was never called (single remote)
  if not ok then
    error(err)
  end
end

-- Opens the current file in the browser
vim.api.nvim_create_user_command("OpenInGithub", function(opts)
  gitbrowse({
    line_start = opts.line1,
    line_end = opts.line2,
  })
end, { range = true })

-- Copy's the current line's github link to the clipboard
vim.api.nvim_create_user_command("GetGithubLink", function(opts)
  gitbrowse({
    line_start = opts.line1,
    line_end = opts.line2,
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { range = true })
