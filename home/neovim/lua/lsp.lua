local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config['ts_ls'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
  capabilities = capabilities,
}

vim.lsp.config['rust_analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml' },
  capabilities = capabilities,
}

vim.lsp.config['zls'] = {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig', 'build.zig.zon' },
  capabilities = capabilities,
}

vim.lsp.config['nixd'] = {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  capabilities = capabilities,
}

vim.lsp.config['pyright'] = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' },
  capabilities = capabilities,
}

vim.lsp.enable({ 'ts_ls', 'rust_analyzer', 'nixd', 'pyright', 'zls' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  end,
})

vim.api.nvim_create_user_command('LspRestart', function()
  for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end
  vim.defer_fn(function() vim.cmd('edit') end, 500)
end, {})
