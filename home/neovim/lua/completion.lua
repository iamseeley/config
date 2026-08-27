local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- jump between snippet placeholders
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if vim.snippet.active({ direction = 1 }) then vim.snippet.jump(1) end
end)
vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if vim.snippet.active({ direction = -1 }) then vim.snippet.jump(-1) end
end)

-- stop :W from erroring
vim.api.nvim_create_user_command('W', 'write', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
