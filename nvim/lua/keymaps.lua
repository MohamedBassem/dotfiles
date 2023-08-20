-- better up/down
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better indentation in visual mode (keep selection)
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Disable highlight
vim.keymap.set({"n", "i"}, "<leader><CR>", "<cmd>noh<CR><esc>")

-- Copy to end
vim.keymap.set("n", "Y", "yg$", { remap = true })

-- LSP Format
vim.keymap.set("n", "<C-f>", ":LspZeroFormat<CR>")

-- Toggle Nvim-Tree
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>")

-- Show current file in Nvim-Tree
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile!<CR>")

-- Buffer movements
vim.keymap.set("n", "tl", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "th", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>t", ":enew<CR>")

-- Don't close the window when closing the buffer
vim.keymap.set("n", "<leader>d", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Black hole deletion/change (persist yanked lines in non-visual mode)
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')
vim.keymap.set("n", "x", '"_x')

-- switch to normal mode with esc in terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- Switch arrows to jump up and down
vim.keymap.set("n", "<Up>", "20k", { noremap = true })
vim.keymap.set("n", "<Down>", "20j", { noremap = true })
vim.keymap.set("n", "<Left>", "20h", { noremap = true })
vim.keymap.set("n", "<Right>", "20l", { noremap = true })

-- Quick exit
vim.keymap.set("n", "<leader>q", ":qa<CR>")

-- Execute code action
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, {})

-- Center search results
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Telescope
local telescope_builtins = require("telescope.builtin")
--vim.keymap.set("n", "<leader>td", telescope_builtins.diagnostics, {})
vim.keymap.set("n", "<leader>gg", telescope_builtins.live_grep, {})
vim.keymap.set('n', '<C-p>', telescope_builtins.find_files, {})
