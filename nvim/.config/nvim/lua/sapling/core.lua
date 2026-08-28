local M = {}

local uv = vim.uv or vim.loop

-- Locate either a regular `.sl` checkout or Sapling's Git-backed `.git/sl`
-- metadata. A nearer ordinary Git repository takes precedence over an outer
-- Sapling checkout.
function M.repo(path)
	if not path or path == "" then
		return nil
	end

	local marker = vim.fs.find({ ".sl", ".git" }, { path = path, upward = true })[1]
	if not marker then
		return nil
	end

	local metadata = vim.fs.basename(marker) == ".sl" and marker or marker .. "/sl"
	if not uv.fs_stat(metadata) then
		return nil
	end

	return { root = vim.fs.dirname(marker), metadata = metadata }
end

-- Run a synchronous Sapling command and return stdout, or nil plus an error.
function M.command(args, cwd)
	local cmd = { "sl" }
	vim.list_extend(cmd, args)
	local out = vim.system(cmd, { cwd = cwd, text = true }):wait()
	if out.code ~= 0 then
		local err = vim.trim(out.stderr or "")
		return nil, err ~= "" and err or vim.trim(out.stdout or "")
	end
	return vim.trim(out.stdout or "")
end

return M
