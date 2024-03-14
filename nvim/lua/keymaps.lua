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
vim.keymap.set("n", "<C-f>", ":LspZeroFormat!<CR>")

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

-- switch to normal mode with esc in terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- Quick exit
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quick exit (close all buffers and exit)" })

-- Execute code action
vim.keymap.set({ "v", "n" }, "<leader>a", require("actions-preview").code_actions, { desc = "[C]ode [Actions]" })

-- Center search results
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true }, { desc = "Center search results" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- When jumping by half-pages, always keep the cursor in the middle
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump half page down and center curson" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump half page up and center curson" })

-- Telescope
vim.keymap.set("n", "<leader>rf", require("telescope.builtin").oldfiles, { desc = "Search [R]ecently opened [F]iles" })
vim.keymap.set("n", "<leader><space>", function() require("telescope.builtin").buffers({ sort_mru = true }) end,
  { desc = "Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]resume" })
vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "[S]earch [Undo]" })
vim.keymap.set("n", "<leader>sc",
  function() require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir() }) end,
  { desc = "[S]earch files in buffer's current dir" })
vim.keymap.set("n", "<leader>sa",
  function() require("telescope.builtin").find_files({ search_file = vim.fn.expand("<cword>") }) end,
  { desc = "[S]earch for file under cusror" })

-- Enable zen mode
vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<CR>", { desc = "Toggle ZenMode" })

-- Persistence
vim.api.nvim_set_keymap(
  "n",
  "<leader>ls",
  [[<cmd>lua require("persistence").load()<cr>]],
  { desc = "Restore [Last] [S]ession for current dir" }
)

-- Vim notify
vim.api.nvim_set_keymap(
  "n",
  "<leader>un",
  [[<cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>]],
  { desc = "Dismiss all notifications" }
)

-- Bufremove
vim.keymap.set("n", "<leader>bd", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", function()
  require("mini.bufremove").delete(0, true)
end, { desc = "Delete buffer (Force)" })

-- Harpoon
vim.keymap.set("n", "<leader>`", function(item) require("harpoon"):list():append() end, { desc = "Harpoon Mark file" })
vim.keymap.set("n", "|", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
  { desc = "Harpoon Toggle quick menu" })

for i = 1, 9, 1 do
  vim.keymap.set("n", "<leader>" .. tostring(i), function() require('harpoon'):list():select(i) end,
    { desc = "Harpoon switch to file #" .. tostring(i) })
end

-- nvim-ufo
vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
vim.keymap.set('n', 'zP', function()
  require('ufo').peekFoldedLinesUnderCursor()
end, { desc = "Preview fold under cursor" })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })


-- Crates
vim.api.nvim_create_user_command('CratesPopup', 'lua require("crates").show_popup()', {})

-- Trouble
vim.keymap.set("n", "<leader>dx", function() require("trouble").toggle("workspace_diagnostics") end)

-- Fterm
vim.keymap.set('n', '<leader>zt', '<CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle FTerm" })
vim.keymap.set('t', '<leader>zt', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { desc = "Toggle Fterm" })
