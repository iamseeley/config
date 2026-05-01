require('telescope').setup{}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Find definitions' })
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { desc = 'Find implementations' })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fw', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
