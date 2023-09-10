-- better up/down
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better indentation in visual mode (keep selection)
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Disable highlight
vim.keymap.set("n", "<leader><CR>", "<cmd>noh<CR><esc>")

-- Copy to end
vim.keymap.set("n", "Y", "yg$", { remap = true })

-- LSP Format
vim.keymap.set("n", "<C-f>", ":LspZeroFormat!<CR>")

-- Toggle Nvim-Tree
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>")

-- Show current file in Nvim-Tree
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile!<CR>", { desc = "Show current file in nvim tree" })

-- Buffer movements
vim.keymap.set("n", "tl", ":BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "th", ":BufferLineCyclePrev<CR>", { desc = "Got to prev buffer" })
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

-- Better split switching
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- Telescope
local telescope_builtins = require("telescope.builtin")
vim.keymap.set('n', '<leader>rf', require('telescope.builtin').oldfiles, { desc = 'Search [R]ecently opened [F]iles' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set("n", "<C-p>", telescope_builtins.find_files, {})
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

-- Enable zen mode
vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<CR>", { desc = "Toggle ZenMode" })

-- Persistence 
vim.api.nvim_set_keymap("n", "<leader>ls", [[<cmd>lua require("persistence").load()<cr>]], { desc = 'Restore [Last] [S]ession for current dir' })

-- Vim notify
vim.api.nvim_set_keymap("n", "<leader>un", [[<cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>]], { desc = 'Dismiss all notifications' })

-- Bufremove
vim.keymap.set('n', '<leader>bd', function() require("mini.bufremove").delete(0, false) end, { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', function() require("mini.bufremove").delete(0, true) end, { desc = 'Delete buffer (Force)' })
