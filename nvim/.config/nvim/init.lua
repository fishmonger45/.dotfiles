vim.o.colorcolumn = '80'
vim.o.vb=true
vim.o.smartcase=true
vim.o.number=true
vim.o.lazyredraw=true
vim.o.showcmd=true
vim.o.hidden=true
vim.o.history=100
vim.o.autoindent=true
vim.o.updatetime=750
vim.o.scrolloff=4
vim.o.laststatus=2
vim.o.ruler=true
vim.o.incsearch=true
vim.o.showmatch=true
vim.o.hlsearch=true
vim.o.foldenable=true
vim.o.shiftwidth=2
vim.g.mapleader=","
vim.o.termguicolors=true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    lazy=false,
    config = function(_, opts)
      require('nvim-treesitter.configs').setup {
	ensure_installed = {"typescript", "tsx", "rust", "python", "graphql"},
	highlight= { enable = true },
	auto_install = true,
	incremental_selection = { enable = true },
	indent = { enable = true }
      }
    end
  },
  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim' },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      mason.setup()
      lspconfig.rust_analyzer.setup({})
      lspconfig.pylsp.setup({
	settings = {
	  pylsp = {
	    plugins = {
	      pylint = {enabled = false},
	      pycodestyle = { enabled = false },
	    },
	  },
	},
      })
      lspconfig.graphql.setup({})
      lspconfig.solargraph.setup({})
      lspconfig.ts_ls.setup({})

      require('mason-lspconfig').setup({
	ensure_installed = {
	  'rust_analyzer',
	  'pylsp',
	  'solargraph',
	  'graphql',
	  'rubocop',
	  'ts_ls'
	},
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      cmp.setup({
	mapping = cmp.mapping.preset.insert({
	  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	  ["<C-f>"] = cmp.mapping.scroll_docs(4),
	  ["<C-Space>"] = cmp.mapping.complete(),
	  ["<C-e>"] = cmp.mapping.abort(),
	  ["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
	  { name = "nvim_lsp" },
	}, {
	  { name = "buffer" },
	}),
      })
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup({
      doc_lines = 0,
      handler_opts = {
	border = "none"
      },
    }) end
  },
  -- misc
  {
    "savq/melange-nvim", 
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme melange]])
    end
  },
  {
    "brenoprata10/nvim-highlight-colors"
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
      })
      vim.keymap.set("n", "<leader>ff", fzf.files, {})
      vim.keymap.set("n", "<leader>fb", fzf.buffers, {})
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, {})
    end
  },
  { 
    "tpope/vim-surround",
    lazy = false
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
	"<leader>?",
	function()
	  require("which-key").show({ global = false })
	end,
	desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({ replace_netrw = true })
      vim.api.nvim_set_keymap("n", "<leader>ef", "", {
	noremap = true,
	callback = function()
	  require("ranger-nvim").open(true)
	end,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    config = function()
    end,
  },
  {
    "vimwiki/vimwiki",
    lazy = false,
    config = function()
    end,
  },
  -- language
  {
    'rust-lang/rust.vim',
    ft = { "rust" },
    config = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_emit_files = 1
      vim.g.rustfmt_fail_silently = 0
      vim.g.rust_clip_command = 'wl-copy'
    end
  },
})

