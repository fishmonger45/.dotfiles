vim.o.colorcolumn = "80"
vim.o.visualbell = true
vim.o.ignorecase = true
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
vim.opt.formatoptions = "cqrnj"
vim.cmd([[colorscheme lunaperche]])

vim.api.nvim_set_keymap('n', '<C-K>', ':bprev<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-J>', ':bnext<CR>',
                        {noremap = true, silent = true})
-- <C-W> d doesn't work with TS symbols. Also gv is already bound!
-- vim.api
--     .nvim_set_keymap('n', ',gv', ':vs<CR>gd', {noremap = true, silent = true})

vim.cmd [[
  augroup strdr4605
    autocmd FileType typescript,typescriptreact set makeprg=./node_modules/.bin/tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'
  augroup END
]]

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
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp-signature-help"
        },
        config = function()
            local cmp = require("cmp")
            vim.opt.completeopt = {"menu", "menuone", "noselect"}

            cmp.setup({
                completion = {
                    autocomplete = false -- Disable automatic completion
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }),
                sources = cmp.config.sources({{name = "nvim_lsp"}}, {
                    {name = "buffer"}, {name = 'nvim_lsp_signature_help'}
                }),
                formatting = {
                    format = function(entry, vim_item)
                        if entry.completion_item.detail ~= nil and
                            entry.completion_item.detail ~= "" then
                            vim_item.menu = entry.completion_item.detail
                        else
                            vim_item.menu = ({
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snippet]",
                                buffer = "[Buffer]",
                                path = "[Path]"
                            })[entry.source.name]
                        end
                        return vim_item
                    end
                }
            })
        end
    }, {
        "metalelf0/jellybeans-nvim",
        lazy = false,
        dependencies = {"rktjmp/lush.nvim"}
    }, {"brenoprata10/nvim-highlight-colors"}, {
        "ibhagwan/fzf-lua",

        opts = {lazy = false},
        config = function()
            require("fzf-lua").setup({
                "hide",
                winopts = {split = "belowright new", preview = {delay = 0}},
                fzf_opts = {
                    ['--history'] = vim.fn.stdpath("data") .. '/fzf-lua-history'
                },
                keymap = {
                    fzf = {
                        true,
                        ["ctrl-q"] = "select-all+accept", -- Send everything to quickfix.
                        ['ctrl-n'] = 'down',
                        ['ctrl-p'] = 'up'
                    }
                }
            })
            vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>",
                           {desc = "Find files"})
            vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<cr>",
                           {desc = "Fzf resume"})
            vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>",
                           {desc = "Grep files"})
            vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<cr>",
                           {desc = "Grep tags in help files"})
            vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua btags<cr>",
                           {desc = "Search buffer tags"})
            vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>",
                           {desc = "Search opened buffers"})
        end
    }, {"tpope/vim-surround"},
    {"vimwiki/vimwiki", lazy = false, config = function() end}, {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
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
                    typescript = {
                        "prettierd",
                        "prettier",
                        stop_after_first = true

                    },
                    javascript = {
                        "prettierd",
                        "prettier",
                        stop_after_first = true
                    },
                    cpp = {"clang-format"}
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

            vim.keymap.set("n", "<leader>fo",
                           "[[:lua require(\"conform\").format({bufnr = vim.api.nvim_get_current_buf()})<CR>]]",
                           {
                desc = "Format buffer",
                noremap = true,
                silent = true
            })
        end

    }, {'stevearc/oil.nvim', opts = {}, lazy = false}, {
        "ggandor/leap.nvim",
        lazy = false,
        config = function()
            local leap = require('leap')
            vim.keymap.set('n', '<leader>s', function()
                require('leap').leap({
                    target_windows = {vim.api.nvim_get_current_win()}
                })
            end)
            -- vim.keymap.set('n', 'gs', '<Plug>(leap-from-window)')  -- or S maybe
            -- vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap-forward)')
            -- vim.keymap.set({'x', 'o'}, 'S', '<Plug>(leap-backward)')
        end

    }, {
        "folke/trouble.nvim",
        opts = {warn_no_results = false, open_no_results = true},
        cmd = "Trouble",
        -- config = function()
        --     -- local config = require("fzf-lua.config")
        --     -- local actions = require("trouble.sources.fzf").actions
        --     -- config.defaults.actions.files["ctrl-t"] = actions.open
        --
        -- end,
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            },
            {
                "<leader>xf",
                "<cmd>Trouble fzf toggle<cr>",
                desc = "Fzf (Trouble)"
            }, {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)"
            }, {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)"
            }, {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)"
            }, {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)"
            }, {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)"
            }
        }
    }, {
        "samharju/serene.nvim",
        -- for using as main:
        enabled = false,
        config = function() vim.cmd.colorscheme("serene") end
    }, {
        "dmmulroy/tsc.nvim",
        config = function()
            local tsc = require('tsc')
            vim.keymap.set('n', '<leader>to', ':TSCOpen<CR>')
            vim.keymap.set('n', '<leader>tc', ':TSCClose<CR>')
        end
    }
})

