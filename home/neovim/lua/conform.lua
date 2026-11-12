-- vim.filetype.add({
--   pattern = {
--     [".*/templates/.*%.html"] = "htmldjango",
--   },
-- })

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    -- htmldjango = { "djlint" },
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
  -- formatters come from home/dev.nix, so they're missing on servers
  notify_no_formatters = false,
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
