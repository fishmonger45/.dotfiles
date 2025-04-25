vim.o.colorcolumn = "80"
vim.o.visualbell = true
vim.o.smartcase = true
vim.o.number = true
vim.o.lazyredraw = true
vim.o.showcmd = true
vim.o.hidden = true
vim.o.history = 100
vim.o.autoindent = true
vim.o.updatetime = 750
vim.o.scrolloff = 4
vim.o.laststatus = 2
vim.o.ruler = true
vim.o.incsearch = true
vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.foldenable = true
vim.o.shiftwidth = 2
vim.g.mapleader = ","
vim.o.termguicolors = true
vim.o.termguicolors = true
vim.cmd([[colorscheme lunaperche]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        config = function(_, opts)
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "typescript", "tsx", "rust", "python", "graphql", "cpp",
                    "html", "css"
                },
                highlight = {enable = true},
                auto_install = true,
                incremental_selection = {enable = true},
                indent = {enable = true}
            })
        end
    }, {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {"williamboman/mason.nvim"}
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
                            pycodestyle = {enabled = false}
                        }
                    }
                }
            })

            lspconfig.rust_analyzer.setup({})
            lspconfig.pylsp.setup({})
            lspconfig.solargraph.setup({})
            lspconfig.graphql.setup({})
            lspconfig.ts_ls.setup({})
            lspconfig.clangd.setup({})
            lspconfig.cssls.setup({})
            lspconfig.lua_ls.setup({})
            lspconfig.rubocop.setup({})

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "rust_analyzer", "pylsp", "solargraph", "graphql", "ts_ls",
                    "clangd", "cssls", "lua_ls", "rubocop"

                }
            })
        end
    }, {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer"
        },
        config = function()
            local cmp = require("cmp")
            vim.opt.completeopt = {"menu", "menuone", "noselect"}

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }),
                sources = cmp.config.sources({{name = "nvim_lsp"}},
                                             {{name = "buffer"}})
            })
        end
    }, {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup({
                doc_lines = 0,
                handler_opts = {border = "none"}
            })
        end
    }, {
        "metalelf0/jellybeans-nvim",
        lazy = false,
        dependencies = {"rktjmp/lush.nvim"}
    }, {"brenoprata10/nvim-highlight-colors"}, {
        "ibhagwan/fzf-lua",
        opts = {lazy = false, winopts = {split = "belowright new"}},
        config = function()
            vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>",
                           {desc = "Fuzzy find files"})
            vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>",
                           {desc = "Fuzzy grep files"})
            vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>",
                           {desc = "Fuzzy grep tags in help files"})
            vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua btags<cr>",
                           {desc = "Fuzzy search buffer tags"})
            vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",
                           {desc = "Fuzzy search opened buffers"})
        end
    }, {"tpope/vim-surround"}, {
        "kelly-lin/ranger.nvim",
        config = function()
            require("ranger-nvim").setup({replace_netrw = true})
            vim.api.nvim_set_keymap("n", "<leader>ef", "", {
                noremap = true,
                callback = function()
                    require("ranger-nvim").open(true)
                end
            })
        end
    }, {"vimwiki/vimwiki", lazy = false, config = function() end}, {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
        dependencies = {
            "nvim-telescope/telescope.nvim", "ibhagwan/fzf-lua",
            "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"
        },
        opts = {}
    }, {
        "juacker/git-link.nvim",
        keys = {
            {
                "<leader>gu",
                function()
                    require("git-link.main").copy_line_url()
                end,
                desc = "Copy code link to clipboard",
                mode = {"n", "x"}
            }, {
                "<leader>go",
                function()
                    require("git-link.main").open_line_url()
                end,
                desc = "Open code link in browser",
                mode = {"n", "x"}
            }
        }
    }, {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {icons = {mappings = false}},
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({global = false})
                end,
                desc = "Buffer Local Keymaps (which-key)"
            }
        }
    }, {"tpope/vim-fugitive"}, {"airblade/vim-gitgutter"}, {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            local confirm = require("conform")
            confirm.setup({
                formatters_by_ft = {
                    lua = {"lua-format", "stylua", stop_after_first = true},
                    python = {"black"},
                    ruby = {"rubocop"},
                    javascript = {
                        "prettierd",
                        "prettier",
                        stop_after_first = true
                    }
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or
                        vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return {timeout_ms = 500, lsp_format = "fallback"}
                end
            })

            vim.g.disable_autoformat = true

            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {desc = "Disable autoformat-on-save", bang = true})

            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {desc = "Re-enable autoformat-on-save"})

            vim.api.nvim_create_user_command("FormatToggle", function()
                if vim.g.disable_autoformat or vim.b.disable_autoformat then
                    vim.cmd('FormatEnable')
                    print("Autoformat is now enabled.")
                else
                    vim.cmd('FormatDisable!')
                    print("Autoformat is now disabled for this buffer.")
                end
            end, {desc = "Toggle autoformat-on-save"})

            vim.api.nvim_set_keymap('n', '<leader>tf', [[:FormatToggle<CR>]],
                                    {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>fo',
                                    [[:lua require("conform").format({bufnr = vim.api.nvim_get_current_buf()})<CR>]],
                                    {noremap = true, silent = true})
        end

    }
})

