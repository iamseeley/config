-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.cmd([[colorscheme mustang]])
vim.opt.clipboard = "unnamedplus"

-- Folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- VimWiki
vim.g.vimwiki_list = {
  {
    path = '~/wiki/',
    syntax = 'markdown',
    ext = '.md',
    template_path = '~/wiki/templates/',
    template_default = 'default',
    template_ext = '.md',
  }
}

-- Conform.nvim
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    json = { "prettierd" },
    markdown = { "prettierd" },
    python = { "black" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Oil.nvim
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })

-- Treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Load modules
require('daily-notes').setup()
require('lsp').setup()
require('completion').setup()
require('telescope').setup()
