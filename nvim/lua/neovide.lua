-- Neovide specific settings
if vim.g.neovide then
  -- Disable horizontal scroll with mouse as it's annoying
  vim.keymap.set("n", "<ScrollWheelRight>", "<Nop>", {});
  vim.keymap.set("n", "<ScrollWheelLeft>", "<Nop>", {});

  -- Mimic tmux movements
  vim.keymap.set("n", "<C-b>h", "<cmd>lua require('tmux').move_left()<CR>", {});
  vim.keymap.set("n", "<C-b>l", "<cmd>lua require('tmux').move_right()<CR>", {});
  vim.keymap.set("n", "<C-b>k", "<cmd>lua require('tmux').move_top()<CR>", {});
  vim.keymap.set("n", "<C-b>j", "<cmd>lua require('tmux').move_bottom()<CR>", {});

  -- GUI features
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0.08
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_padding_top = 2
  vim.g.neovide_padding_bottom = 2
  vim.g.neovide_padding_right = 2
  vim.g.neovide_padding_left = 2
  vim.o.guifont = "MesloLGL_Nerd_Font"

  -- Restore command key functionality
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})


  -- FTerm
  vim.keymap.set('n', '<C-b>z', '<CMD>lua require("FTerm").toggle()<CR>')
  vim.keymap.set('t', '<C-b>z', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

end
