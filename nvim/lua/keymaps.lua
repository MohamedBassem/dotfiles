-- better up/down
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Search and replace for the word under cursor
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })

-- Better indentation in visual mode (keep selection)
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Disable highlight
vim.keymap.set("n", "<leader><CR>", "<cmd>noh<CR><esc>")

-- Copy to end
vim.keymap.set("n", "Y", "yg$", { remap = true })

-- LSP Format
vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format({ async = true }) end)

-- Buffer movements
vim.keymap.set("n", "tl", ":lua require('harpoon'):list():next()<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "th", ":lua require('harpoon'):list():prev()<CR>", { desc = "Got to prev buffer" })
vim.keymap.set("n", "<leader>t", ":enew<CR>", { desc = "Open a new file" })

-- Black hole deletion/change (persist yanked lines in non-visual mode)
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("n", "x", '"_x')

-- Map arrows to scroll
vim.keymap.set("n", "<Up>", "<C-Y>", { desc = "Scroll up" })
vim.keymap.set("n", "<Down>", "<C-E>", { desc = "Scroll down" })

-- switch to normal mode with esc in terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- Quick exit
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quick exit (close all buffers and exit)" })

-- Execute code action
vim.keymap.set({ "v", "n" }, "<leader>a", vim.lsp.buf.code_action, { desc = "[C]ode [Actions]" })

-- Center search results
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true, desc = "Center search results" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- Reset diagnostics
vim.keymap.set("n", "<leader>dr", vim.diagnostic.reset, { desc = "Reset diagnostics" })

-- Snacks Picker
vim.keymap.set("n", "<leader>rf", function() Snacks.picker.recent() end, { desc = "Search [R]ecently opened [F]iles" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end,
  { desc = "Find existing buffers" })
vim.keymap.set("n", "<C-p>", function() Snacks.picker.files() end, {})
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "[S]earch [R]resume" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "[S]earch [U]ndo" })
vim.keymap.set("n", "<leader>sp", function() Snacks.picker() end, { desc = "[S]earch [P]icker" })

-- Enable zen mode
vim.keymap.set("n", "<leader>zz", function() Snacks.zen.zoom() end, { desc = "Toggle ZenMode" })

-- Vim notify
vim.api.nvim_set_keymap(
  "n",
  "<leader>un",
  [[<cmd>lua Snacks.notifier.hide() <cr>]],
  { desc = "Dismiss all notifications" }
)

-- Bufdelete
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })

-- Harpoon
vim.keymap.set("n", "<leader>`", function() require("harpoon"):list():add() end, { desc = "Harpoon Mark file" })
vim.keymap.set("n", "|", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
  { desc = "Harpoon Toggle quick menu" })

for i = 1, 9, 1 do
  vim.keymap.set("n", "<leader>" .. tostring(i), function() require('harpoon'):list():select(i) end,
    { desc = "Harpoon switch to file #" .. tostring(i) })
end

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Crates
vim.api.nvim_create_user_command('CratesPopup', 'lua require("crates").show_popup()', {})

-- Trouble
vim.keymap.set("n", "<leader>dx", function() require("trouble").toggle("workspace_diagnostics") end)

-- Typescript
vim.keymap.set("n", "<leader>ip", '<CMD>TSToolsAddMissingImports<CR>', { desc = "Typescript: Add missing imports" })
vim.keymap.set("n", "<leader>io", '<CMD>TSToolsOrganizeImports<CR>', { desc = "Typescript: Organize imports" })

-- Other
vim.keymap.set("n", "<leader>o", '<CMD>Other<CR>', { desc = "Switch to the [O]ther file" })

-- Supermaven

vim.keymap.set('i', '<C-J>', function()
  local suggestion = require('supermaven-nvim.completion_preview');
  if suggestion.has_suggestion() then
    suggestion.on_accept_suggestion()
  end
end, {
  desc = "Supermaven: Accept completion"
})

vim.keymap.set({ "v", "n" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Jump to next word" })
vim.keymap.set({ "v", "n" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Jump to previous word" })

vim.keymap.set('n', 'gL', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })
