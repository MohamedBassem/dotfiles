
-- Configure Telescope

require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>td", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>gg", builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
