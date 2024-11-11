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
  { "tpope/vim-surround", lazy = false },
  { "stevearc/oil.nvim", lazy = false, opts = {}, },
  { "neovim/nvim-lspconfig",
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

      require('mason-lspconfig').setup({
	ensure_installed = {
	  'rust_analyzer',
	  'pylsp',
	  'solargraph',
	  'graphql',
	  'rubocop'
	},
      })
    end,
  },
  { "brenoprata10/nvim-highlight-colors" },
  { "ibhagwan/fzf-lua",
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      cmp.setup({
	snippet = {
	  expand = function(args)
	    require("luasnip").lsp_expand(args.body)
	  end,
	},
	mapping = cmp.mapping.preset.insert({
	  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	  ["<C-f>"] = cmp.mapping.scroll_docs(4),
	  ["<C-Space>"] = cmp.mapping.complete(),
	  ["<C-e>"] = cmp.mapping.abort(),
	  ["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
	  { name = "nvim_lsp" },
	  { name = "nvim_lua" },
	  { name = "luasnip" },
	}, {
	  { name = "buffer" },
	  { name = "path" },
	}),
      })

      cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
	  { name = "path" },
	}, {
	  { name = "cmdline" },
	}),
      })
    end
  },
  { "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {
    "metalelf0/jellybeans-nvim", 
    dependencies = {"rktjmp/lush.nvim"},
    lazy = false,
    priority = 1000, -- load first
    config = function()
      vim.cmd([[colorscheme jellybeans-nvim]])
    end
  },
})

