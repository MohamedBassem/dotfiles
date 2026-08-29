local M = {}

local DEFAULT_NAME = "default"
local CREATE_NEW = {}
local ACTIVE_LIST_STORAGE = "__harpoon_active_list"
local active_names = {}
local loaded_projects = {}

local function harpoon()
	return require("harpoon")
end

local function project_key()
	return harpoon().config.settings.key()
end

local function storage_name(name)
	if name == nil or name == DEFAULT_NAME then
		return nil
	end
	return name
end

function M.name()
	local key = project_key()
	if not loaded_projects[key] then
		loaded_projects[key] = true
		local item = harpoon():list(ACTIVE_LIST_STORAGE):get(1)
		if item and type(item.value) == "string" and item.value ~= "" then
			active_names[key] = item.value
		end
	end

	return active_names[key] or DEFAULT_NAME
end

function M.list()
	return harpoon():list(storage_name(M.name()))
end

function M.switch(name)
	name = vim.trim(name or "")
	if name == "" then
		return
	end

	local key = project_key()
	active_names[key] = name
	loaded_projects[key] = true

	-- Instantiate and sync the list so even a newly created empty list is
	-- discoverable after restarting Neovim.
	local list = M.list()
	local active_list_storage = harpoon():list(ACTIVE_LIST_STORAGE)
	active_list_storage:clear()
	active_list_storage:add({ value = name, context = {} })
	harpoon():sync()
	vim.notify(string.format("Harpoon list: %s (%d files)", M.name(), list:length()))
end

local function available_lists()
	local h = harpoon()
	local key = project_key()
	local default_storage_name = h:info().default_list_name
	local stored = h:dump()[key] or {}
	local names = {}

	for name in pairs(stored) do
		if name ~= default_storage_name and name ~= ACTIVE_LIST_STORAGE then
			table.insert(names, name)
		end
	end
	table.sort(names)
	table.insert(names, 1, DEFAULT_NAME)

	return names
end

function M.delete(name)
	if name == DEFAULT_NAME then
		vim.notify("The default Harpoon list cannot be deleted", vim.log.levels.WARN)
		return
	end

	local h = harpoon()
	local key = project_key()
	local stored = h:dump()[key]
	if stored == nil or stored[name] == nil then
		vim.notify("Harpoon list not found: " .. name, vim.log.levels.WARN)
		return
	end

	stored[name] = nil
	if h.lists[key] then
		h.lists[key][name] = nil
	end

	if M.name() == name then
		active_names[key] = DEFAULT_NAME
		local active_list_storage = h:list(ACTIVE_LIST_STORAGE)
		active_list_storage:clear()
		active_list_storage:add({ value = DEFAULT_NAME, context = {} })
	end

	h:sync()
	vim.notify("Deleted Harpoon list: " .. name)
end

function M.select()
	local items = available_lists()
	table.insert(items, CREATE_NEW)

	vim.ui.select(items, {
		prompt = string.format("Harpoon list (current: %s)", M.name()),
		format_item = function(item)
			if item == CREATE_NEW then
				return "+ Create new list..."
			end

			local name = storage_name(item)
			local count = harpoon():list(name):length()
			local marker = item == M.name() and "* " or "  "
			return string.format("%s%s (%d)", marker, item, count)
		end,
	}, function(choice)
		if choice == nil then
			return
		end
		if choice ~= CREATE_NEW then
			M.switch(choice)
			return
		end

		vim.ui.input({ prompt = "New Harpoon list: " }, function(name)
			M.switch(name)
		end)
	end)
end

function M.select_delete()
	local items = available_lists()
	table.remove(items, 1)
	if #items == 0 then
		vim.notify("No named Harpoon lists to delete", vim.log.levels.INFO)
		return
	end

	vim.ui.select(items, {
		prompt = "Delete Harpoon list:",
		format_item = function(item)
			local count = harpoon():list(item):length()
			local marker = item == M.name() and "* " or "  "
			return string.format("%s%s (%d)", marker, item, count)
		end,
	}, function(choice)
		if choice == nil then
			return
		end

		vim.ui.select({ "Cancel", "Delete" }, {
			prompt = string.format("Delete Harpoon list '%s'?", choice),
		}, function(action)
			if action == "Delete" then
				M.delete(choice)
			end
		end)
	end)
end

return M
