{ config, pkgs, lib, ... }:

# ============================================================================
# SPIDYNIX NEOVIM CONFIGURATION
# ============================================================================
# Modern Neovim setup with LSP, Telescope, Treesitter, and plugins
# Optimized for Colemak DH and Wayland
# ============================================================================

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # =========================================================================
    # NEOVIM PLUGINS
    # =========================================================================
    plugins = with pkgs.vimPlugins; [
      # --- File Navigation ---
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-tree-lua

      # --- LSP Support ---
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip

      # --- Syntax & Treesitter ---
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects

      # --- UI Enhancements ---
      lualine-nvim
      nvim-web-devicons
      bufferline-nvim
      indent-blankline-nvim
      which-key-nvim

      # --- Git Integration ---
      gitsigns-nvim
      vim-fugitive

      # --- Editing ---
      comment-nvim
      nvim-autopairs
      vim-surround

      # --- Color Schemes ---
      tokyonight-nvim
      catppuccin-nvim
      gruvbox-nvim

      # --- Utilities ---
      plenary-nvim
    ];

    # =========================================================================
    # NEOVIM CONFIGURATION
    # =========================================================================
    extraLuaConfig = ''
      -- Performance optimization
      if vim.loader then
        vim.loader.enable()
      end

      -- ===================================================================
      -- BASIC SETTINGS
      -- ===================================================================
      vim.opt.number = true
      vim.opt.relativenumber = true

      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.autoindent = true

      vim.opt.wrap = false
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.cursorline = true

      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      vim.opt.signcolumn = "yes"

      vim.opt.backspace = "indent,eol,start"
      vim.opt.clipboard:append("unnamedplus")

      vim.opt.splitright = true
      vim.opt.splitbelow = true
      vim.opt.mouse = "a"

      -- ===================================================================
      -- KEYMAPS
      -- ===================================================================
      vim.g.mapleader = " "
      local keymap = vim.keymap

      keymap.set("n", "<leader>nh", ":nohl<CR>")

      keymap.set("n", "<leader>sv", "<C-w>v")
      keymap.set("n", "<leader>sh", "<C-w>s")
      keymap.set("n", "<leader>se", "<C-w>=")
      keymap.set("n", "<leader>sx", ":close<CR>")

      keymap.set("n", "<leader>bn", ":bnext<CR>")
      keymap.set("n", "<leader>bp", ":bprevious<CR>")
      keymap.set("n", "<leader>bd", ":bdelete<CR>")

      -- ===================================================================
      -- PLUGIN CONFIGURATION
      -- ===================================================================
      vim.cmd[[colorscheme tokyonight]]

      require('Comment').setup()
      require('nvim-autopairs').setup()
      require('gitsigns').setup()

      require('lualine').setup({
        options = { theme = 'tokyonight' }
      })

      -- ===================================================================
      -- LSP CONFIGURATION
      -- ===================================================================
      local lspconfig = require('lspconfig')

      lspconfig.nil_ls.setup{}
      lspconfig.rust_analyzer.setup{}
      lspconfig.tsserver.setup{}
      lspconfig.bashls.setup{}

      -- ===================================================================
      -- COMPLETION CONFIGURATION
      -- ===================================================================
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- ===================================================================
      -- TELESCOPE CONFIGURATION
      -- ===================================================================
      local telescope = require('telescope')
      telescope.setup()
      telescope.load_extension('fzf')

      keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
      keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
      keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
      keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

      -- ===================================================================
      -- TREESITTER CONFIGURATION
      -- ===================================================================
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    '';
  };
}
# USAGE:
# - Launch: nvim
# - Leader key: Space
#
# KEY BINDINGS:
# - <leader>ff: Find files (Telescope)
# - <leader>fg: Live grep (search in files)
# - <leader>fb: List buffers
# - <leader>bn: Next buffer
# - <leader>bp: Previous buffer
# - <leader>bd: Delete buffer
# - <leader>sv: Split vertically
# - <leader>sh: Split horizontally
# - <leader>nh: Clear search highlights
#
# LSP:
# - gd: Go to definition
# - gr: Go to references
# - K: Show hover documentation
# - <leader>ca: Code actions
#
# COMPLETION:
# - <C-Space>: Trigger completion
# - <CR>: Confirm selection
# - <C-e>: Abort completion
#
# CUSTOMIZATION:
# - Add more plugins to the plugins list
# - Add more LSP servers in extraPackages and configuration
# - Modify keymaps in extraLuaConfig
# - Change colorscheme in extraLuaConfig
#
# LEARNING:
# - :help - Built-in help
# - :Tutor - Interactive tutorial
# - :checkhealth - Check configuration
# ============================================================================
