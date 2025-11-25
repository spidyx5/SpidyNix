# /etc/nixos/SpidyNix/Homes/devs/neovim.nix
{ config, pkgs, lib, ... }:
{
  # Enable Neovim
  programs.neovim = {
    enable = true;  # Enable Neovim
    defaultEditor = true;  # Set as default EDITOR
    viAlias = true;  # Create 'vi' alias
    vimAlias = true;  # Create 'vim' alias
    vimdiffAlias = true;  # Create 'vimdiff' alias

    # ============================================================================
    # NEOVIM PLUGINS
    # ============================================================================
    # Essential plugins for a modern Neovim experience
    # ============================================================================

    plugins = with pkgs.vimPlugins; [
      # --- File Navigation ---
      telescope-nvim                # Fuzzy finder
      telescope-fzf-native-nvim     # FZF sorter for telescope
      nvim-tree-lua                 # File explorer

      # --- LSP Support ---
      nvim-lspconfig                # LSP configurations
      nvim-cmp                      # Completion engine
      cmp-nvim-lsp                  # LSP completion source
      cmp-buffer                    # Buffer completion source
      cmp-path                      # Path completion source
      cmp-cmdline                   # Cmdline completion
      luasnip                       # Snippet engine
      cmp_luasnip                   # Snippet completion source

      # --- Syntax & Treesitter ---
      nvim-treesitter.withAllGrammars  # Syntax highlighting
      nvim-treesitter-textobjects   # Treesitter text objects

      # --- UI Enhancements ---
      lualine-nvim                  # Status line
      nvim-web-devicons             # File icons
      bufferline-nvim               # Buffer/tab line
      indent-blankline-nvim         # Indent guides
      which-key-nvim                # Keybinding helper

      # --- Git Integration ---
      gitsigns-nvim                 # Git signs in gutter
      vim-fugitive                  # Git commands

      # --- Editing ---
      comment-nvim                  # Easy commenting
      nvim-autopairs                # Auto close brackets
      vim-surround                  # Surround text objects

      # --- Color Schemes ---
      tokyonight-nvim               # Tokyo Night theme
      catppuccin-nvim               # Catppuccin theme
      gruvbox-nvim                  # Gruvbox theme

      # --- Utilities ---
      plenary-nvim                  # Lua utilities (required by many plugins)
    ];
    # ============================================================================
    # NEOVIM CONFIGURATION
    # ============================================================================
    # Lua configuration for Neovim
    # ============================================================================

    extraLuaConfig = ''
      -- ======================================================================
      -- PERFORMENCE OPTIMIZATIONS
      if vm.loader then
         vim.loader.enable()
      end
      -- BASIC SETTINGS
      -- ======================================================================
      -- Line numbers
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Tabs and indentation
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.autoindent = true

      -- Line wrapping
      vim.opt.wrap = false

      -- Search settings
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Cursor line
      vim.opt.cursorline = true

      -- Appearance
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      vim.opt.signcolumn = "yes"

      -- Backspace
      vim.opt.backspace = "indent,eol,start"

      -- Clipboard (use system clipboard)
      vim.opt.clipboard:append("unnamedplus")

      -- Split windows
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- Mouse
      vim.opt.mouse = "a"

      -- ======================================================================
      -- KEYMAPS
      -- ======================================================================

      -- Set leader key
      vim.g.mapleader = " "

      local keymap = vim.keymap

      -- Clear search highlights
      keymap.set("n", "<leader>nh", ":nohl<CR>")

      -- Window management
      keymap.set("n", "<leader>sv", "<C-w>v")     -- Split vertically
      keymap.set("n", "<leader>sh", "<C-w>s")     -- Split horizontally
      keymap.set("n", "<leader>se", "<C-w>=")     -- Equal width
      keymap.set("n", "<leader>sx", ":close<CR>") -- Close split

      -- Buffer management
      keymap.set("n", "<leader>bn", ":bnext<CR>")     -- Next buffer
      keymap.set("n", "<leader>bp", ":bprevious<CR>") -- Previous buffer
      keymap.set("n", "<leader>bd", ":bdelete<CR>")   -- Delete buffer

      -- ======================================================================
      -- PLUGIN CONFIGURATION
      -- ======================================================================

      -- Colorscheme
      vim.cmd[[colorscheme tokyonight]]

      -- Comment.nvim
      require('Comment').setup()

      -- Autopairs
      require('nvim-autopairs').setup()

      -- Gitsigns
      require('gitsigns').setup()

      -- Lualine
      require('lualine').setup({
        options = {
          theme = 'tokyonight'
        }
      })

      -- ======================================================================
      -- LSP CONFIGURATION
      -- ======================================================================

      local lspconfig = require('lspconfig')

      -- Nix
      lspconfig.nil_ls.setup{}

      -- Rust
      lspconfig.rust_analyzer.setup{}

      -- TypeScript
      lspconfig.tsserver.setup{}

      -- Bash
      lspconfig.bashls.setup{}


      -- ======================================================================
      -- COMPLETION CONFIGURATION
      -- ======================================================================

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

      -- ======================================================================
      -- TELESCOPE CONFIGURATION
      -- ======================================================================

      local telescope = require('telescope')
      telescope.setup()
      telescope.load_extension('fzf')

      -- Telescope keymaps
      keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
      keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
      keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
      keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

      -- ======================================================================
      -- TREESITTER CONFIGURATION
      -- ======================================================================

      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    '';
  };
}
# ============================================================================
# NEOVIM CONFIGURATION
# ============================================================================
# This file configures Neovim for user 'spidy'.
# Neovim is a modern, extensible Vim-based text editor.
#
# Home Manager module for Neovim configuration.
# ============================================================================
# ============================================================================
# NOTES
# ============================================================================
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
