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
  local ok, err = pcall(function()
    if not require("sapling.gitbrowse").open(opts) then
      Snacks.gitbrowse(opts)
    end
  end)
  vim.ui.select = select -- restore in case it was never called (single remote)
  if not ok and err ~= "__ignore__" then
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

-- Ask Codex about the current line or a visual selection.
local codex_buf
local codex_job

local function codex_prompt(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  local location = string.format("%s:%d-%d", path ~= "" and path or "[No Name]", opts.line1, opts.line2)
  return string.format("%s Look at %s.", opts.args, location)
end

local function show_codex()
  local win = vim.fn.bufwinid(codex_buf)
  if win == -1 then
    vim.cmd("botright vertical sbuffer " .. codex_buf)
  else
    vim.api.nvim_set_current_win(win)
  end
  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Codex", function(opts)
  local running = codex_job
    and vim.api.nvim_buf_is_valid(codex_buf)
    and vim.fn.jobwait({ codex_job }, 0)[1] == -1

  if running then
    if opts.args == "" then
      local win = vim.fn.bufwinid(codex_buf)
      if win == -1 then
        show_codex()
      else
        vim.api.nvim_win_hide(win)
      end
    else
      local prompt = codex_prompt(opts)
      show_codex()
      vim.api.nvim_chan_send(codex_job, prompt .. "\r")
    end
    return
  end

  codex_buf = nil
  codex_job = nil
  if opts.args == "" then
    vim.notify("Codex is not running; pass a prompt to start it", vim.log.levels.WARN)
    return
  end

  local prompt = codex_prompt(opts)
  vim.cmd("botright vnew")
  codex_buf = vim.api.nvim_get_current_buf()
  codex_job = vim.fn.jobstart({ "codex", prompt }, {
    cwd = vim.fn.getcwd(),
    term = true,
  })
  if codex_job <= 0 then
    codex_buf = nil
    codex_job = nil
    vim.notify("Could not start Codex", vim.log.levels.ERROR)
    return
  end
  vim.bo[codex_buf].bufhidden = "hide"
  vim.cmd("startinsert")
end, { desc = "Toggle Codex or ask about selected lines", nargs = "*", range = true })
