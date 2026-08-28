local M = {}

local core = require("sapling.core")

local function command(args, root)
	local output, err = core.command(args, root)
	if not output then
		Snacks.notify.error({ "Sapling command failed", err }, { title = "Git Browse" })
		error("__ignore__")
	end
	return output
end

-- Handle Snacks.gitbrowse-compatible options for the current Sapling buffer.
-- Returns false when the buffer is not in a Sapling checkout, allowing the
-- caller to fall back to Snacks' normal Git implementation.
function M.open(opts)
	local file = vim.api.nvim_buf_get_name(0)
	local repo = file ~= "" and core.repo(vim.fs.dirname(file)) or nil
	if not repo then
		return false
	end

	local fields = {
		commit = command({ "whereami" }, repo.root),
		file = file:sub(#repo.root + 2),
		line_start = opts.line_start or vim.fn.line("."),
		line_end = opts.line_end or opts.line_start or vim.fn.line("."),
	}
	fields.line_count = fields.line_end - fields.line_start + 1

	-- Sapling does not require a branch/bookmark, so use the current commit for
	-- a stable link to the selected file and line range.
	local browse_opts = vim.tbl_extend("force", opts, { what = "permalink" })
	local remotes = {}
	for line in command({ "path" }, repo.root):gmatch("[^\r\n]+") do
		local name, remote = line:match("^([^%s=]+)%s*=%s*(.+)$")
		if name and remote then
			local remote_repo = Snacks.gitbrowse.get_repo(remote, browse_opts)
			remotes[#remotes + 1] = {
				name = name,
				url = Snacks.gitbrowse.get_url(remote_repo, fields, browse_opts),
			}
		end
	end

	local function open(remote)
		if not remote then
			return
		end
		if opts.notify ~= false then
			Snacks.notify(("Opening [%s](%s)"):format(remote.name, remote.url), { title = "Git Browse" })
		end
		if opts.open then
			opts.open(remote.url)
		else
			vim.ui.open(remote.url)
		end
	end

	if #remotes == 0 then
		Snacks.notify.error("No Sapling remotes found", { title = "Git Browse" })
	elseif #remotes == 1 then
		open(remotes[1])
	else
		vim.ui.select(remotes, {
			prompt = "Select remote to browse",
			format_item = function(item)
				return item.name .. " 🔗 " .. item.url
			end,
		}, open)
	end

	return true
end

return M
