local M = {}

local directions = {
	h = "left",
	j = "down",
	k = "up",
	l = "right",
}

local function focus_herdr(direction)
	if vim.env.HERDR_ENV ~= "1" then
		return
	end

	local herdr = vim.env.HERDR_BIN_PATH
	if not herdr or herdr == "" then
		herdr = vim.fn.exepath("herdr")
	end
	if herdr == "" then
		return
	end

	local command = { herdr, "pane", "focus", "--direction", direction }
	local pane = vim.env.HERDR_PANE_ID
	if pane and pane ~= "" then
		vim.list_extend(command, { "--pane", pane })
	else
		table.insert(command, "--current")
	end

	-- Do not block Neovim while Herdr updates the outer layout.
	vim.system(command, { text = true }, function() end)
end

function M.navigate(key)
	local direction = directions[key]
	if not direction then
		error("unknown navigation key: " .. tostring(key))
	end

	local current = vim.api.nvim_get_current_win()
	local neighbor = vim.fn.win_getid(vim.fn.winnr(key))

	if neighbor ~= 0 and neighbor ~= current and vim.api.nvim_win_is_valid(neighbor) then
		vim.api.nvim_set_current_win(neighbor)
		return
	end

	focus_herdr(direction)
end

function M.setup()
	for key, direction in pairs(directions) do
		vim.keymap.set("n", "<C-w>" .. key, function()
			M.navigate(key)
		end, {
			desc = "Navigate " .. direction .. " across Neovim/Herdr",
			silent = true,
		})
		vim.keymap.set(
			"t",
			"<C-w>" .. key,
			string.format([[<C-\><C-n><Cmd>lua require("herdr_navigation").navigate("%s")<CR>]], key),
			{
				desc = "Navigate " .. direction .. " across Neovim/Herdr",
				silent = true,
			}
		)
	end
end

return M
