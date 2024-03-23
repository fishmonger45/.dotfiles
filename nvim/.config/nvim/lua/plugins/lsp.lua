return {
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
	lspconfig.tsserver.setup({})
	lspconfig.solargraph.setup({})

	require('mason-lspconfig').setup({
	    ensure_installed = {
		'rust_analyzer',
		'tsserver',
		'ruby_ls',
		'rubocop'
	    },
	})
    end,


}
