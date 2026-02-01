{ config, pkgs, ... }:

let
  neovimPackages = with pkgs; [
    typescript-language-server
    rust-analyzer
    nixd
    pyright
    ripgrep
    fd
    prettierd
    black
    rustfmt
    nixfmt-rfc-style
  ];
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      (pkgs.vimUtils.buildVimPlugin {
        name = "mustang-vim";
        src = pkgs.fetchFromGitHub {
          owner = "croaker";
          repo = "mustang-vim";
          rev = "master";
          sha256 = "sha256-x/DEX2XoaKdrWuGvfa21laJgHEgRw7xjnG1IAnJmlX4=";
        };
      })

      (nvim-treesitter.withPlugins (p: [
        p.javascript
        p.typescript
        p.tsx
        p.rust
        p.nix
        p.python
        p.lua
        p.vim
        p.json
        p.markdown
        p.bash
      ]))

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      telescope-nvim
      plenary-nvim
      vimwiki
      oil-nvim
      conform-nvim
    ];

    extraPackages = neovimPackages;

    initLua = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.cmd([[colorscheme mustang]])

      -- Enable folding
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldlevel = 99  -- Open all folds by default
      vim.opt.foldlevelstart = 99

      -- VimWiki configuration
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

      -- Conform.nvim formatting configuration
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

      -- Manual format keymap
      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })

      -- Oil.nvim configuration
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })

      -- Open oil file explorer (changed from - to avoid VimWiki conflict)
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })

      -- Function to open today's daily note and add to index
      local function open_daily_note()
        local date = os.date("%Y-%m-%d")
        local daily_path = vim.fn.expand("~/wiki/notes/daily/" .. date .. ".md")
        local index_path = vim.fn.expand("~/wiki/notes/daily/index.md")
        
        vim.fn.mkdir(vim.fn.expand("~/wiki/notes/daily"), "p")
        
        local file_exists = vim.fn.filereadable(daily_path) == 1
        
        if not file_exists then
          local index_exists = vim.fn.filereadable(index_path) == 1
          local lines = {}
          
          if index_exists then
            lines = vim.fn.readfile(index_path)
          else
            lines = {"# Daily Notes", ""}
          end
          
          local insert_pos = 2
          for i, line in ipairs(lines) do
            if line:match("^- %[%[") then
              insert_pos = i
              break
            end
          end
          
          table.insert(lines, insert_pos, "- [[" .. date .. "]]")
          vim.fn.writefile(lines, index_path)
        end
        
        vim.cmd("edit " .. daily_path)
        
        if not file_exists then
          local template_content = {
            "# " .. date,
            "",
            "**Date:** " .. os.date("%A, %B %d, %Y"),
            "",
            "## Tasks",
            "- [ ] ",
            "",
            "## Notes",
            "",
            "",
            "## Log",
            "",
            ""
          }
          vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content)
        end
      end

      -- Wiki navigation keymaps
      vim.keymap.set('n', '<leader>nd', open_daily_note, { desc = 'Today daily note' })
      vim.keymap.set('n', '<leader>nD', '<cmd>e ~/wiki/notes/daily/index.md<CR>', { desc = 'Daily notes index' })
      vim.keymap.set('n', '<leader>nw', '<cmd>e ~/wiki/notes/weekly/index.md<CR>', { desc = 'Weekly notes' })
      vim.keymap.set('n', '<leader>nm', '<cmd>e ~/wiki/notes/monthly/index.md<CR>', { desc = 'Monthly notes' })
      vim.keymap.set('n', '<leader>ny', '<cmd>e ~/wiki/notes/yearly/index.md<CR>', { desc = 'Yearly notes' })
      vim.keymap.set('n', '<leader>ni', '<cmd>e ~/wiki/index.md<CR>', { desc = 'Wiki index' })

      -- Treesitter auto-enables when parsers are installed
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if not ok then
            -- Silently fail if no parser available
          end
        end,
      })

      -- LSP setup
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

      vim.lsp.enable({ 'ts_ls', 'rust_analyzer', 'nixd', 'pyright' })

      -- Completion setup
      local cmp = require('cmp')
      cmp.setup({
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

      -- Telescope setup
      require('telescope').setup{}

      -- Telescope keymaps
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    '';
  };

  home.packages = neovimPackages;
}
