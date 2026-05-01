require('mini.diff').setup({
  view = { style = 'sign' },
})

require('mini.git').setup()

vim.keymap.set('n', '<leader>go', function()
  MiniDiff.toggle_overlay()
end, { desc = 'Toggle diff overlay' })
