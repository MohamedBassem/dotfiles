local M = {}

-- Filenames that are ambiguous on their own; render with their parent dir.
local AMBIGUOUS_NAMES = {
	["mod.rs"] = true,
	["lib.rs"] = true,
	["main.rs"] = true,
	["index.js"] = true,
	["index.ts"] = true,
	["init.lua"] = true,
}

-- Returns the display name for a harpoon path, including the parent dir for
-- ambiguous filenames like mod.rs / lib.rs (e.g. "parser/mod.rs").
local function harpoon_display_name(path)
	if path == "" then
		return "(empty)"
	end
	local tail = vim.fn.fnamemodify(path, ":t")
	if AMBIGUOUS_NAMES[tail] then
		local dir = vim.fn.fnamemodify(path, ":h")
		local parent = vim.fn.fnamemodify(dir, ":t")
		-- "src" alone is ambiguous across crates; skip to the crate name.
		if parent == "src" then
			local crate = vim.fn.fnamemodify(dir, ":h:t")
			if crate ~= "" and crate ~= "." then
				parent = crate
			end
		end
		if parent ~= "" and parent ~= "." then
			return parent .. "/" .. tail
		end
	end
	return tail
end

-- A function that returns the list of harpoon files to use in lualine
-- Copied from: https://github.com/ThePrimeagen/harpoon/issues/352#issuecomment-1873053256
-- TODO: Remove when harpoon lands official support
function M.harpoon_files()
	local harpoon = require("harpoon")
	local contents = {}
	local marks_length = harpoon:list():length()
	local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
	for index = 1, marks_length do
		local harpoon_file_path = harpoon:list():get(index).value
		local file_name = harpoon_display_name(harpoon_file_path)

		if current_file_path == harpoon_file_path then
			contents[index] =
			string.format("%%#HarpoonNumberActive# %s. %%#HarpoonActive#%s ", index, file_name)
		else
			contents[index] =
			string.format("%%#HarpoonNumberInactive# %s. %%#HarpoonInactive#%s ", index, file_name)
		end
	end

	return table.concat(contents)
end

return M
