M = {
    { "Airbus5717/c3.vim" },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },

    {
        'lervag/vimtex',
        lazy = false,
        config = function()
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            }
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config('*', {
                capabilities = require('cmp_nvim_lsp').default_capabilities()
            })

            -- C / C++: Use clangd for everything
            -- Python: use Ruff for {formating, linting, organising imports}, Pylsp for completions
            -- Lua: Use lua_ls with lazydev for config writing
            -- LaTeX: use texlab for everything

            local servers = { 'clangd', 'ruff', 'pylsp', 'lua_ls', 'texlab' }
            for _, server in ipairs(servers) do
                vim.lsp.enable(server)
            end

            vim.lsp.config('pylsp', {
                settings = {
                    pylsp = {
                        -- Ruff does this for us but faster
                        plugins = {
                            autopep8    = { enabled = false },
                            mccabe      = { enabled = false },
                            preload     = { enabled = false },
                            pycodestyle = { enabled = false },
                        }
                    }
                }
            })

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '🌺',
                        [vim.diagnostic.severity.WARN] = '🌻',
                        [vim.diagnostic.severity.INFO] = '🍇',
                        [vim.diagnostic.severity.HINT] = '🫐',
                    }
                }
            })

            local set = vim.keymap.set
            local bufopts = { noremap = true, silent = true }

            -- In the future, we might add more of rustaceanvims functionality

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    if client ~= nil and client.name == 'rust_analyzer' then
                        set("n", "K", function()
                            vim.cmd.RustLsp({ 'hover', 'actions' })
                        end, bufopts)
                        set("n", "<leader>a", function()
                            vim.cmd.RustLsp('codeAction')
                        end, bufopts)
                    else
                        set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
                        set("n", "K", vim.lsp.buf.hover, bufopts)
                    end
                    set("n", "<leader>f", vim.lsp.buf.format, bufopts)
                    set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
                    set("n", "<leader>e", vim.diagnostic.open_float, bufopts)
                    set("n", "gD", vim.lsp.buf.declaration, bufopts)
                    set("n", "gd", vim.lsp.buf.definition, bufopts)
                    set("n", "gi", vim.lsp.buf.implementation, bufopts)
                end
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                -- mypy: Static type analysis for Python
                python = { 'mypy' }
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require('lint').try_lint()
                end
            })
        end
    },


    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            handler_opts = {
                border = "rounded"
            },
            hint_prefix = '🌈 ',
            floating_window = false
        }
    },

    {
        "mrcjkb/rustaceanvim",
        version = '^6',
        lazy = false,

    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({
                                    select = false
                                })
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expandable() or luasnip.locally_jumpable(1) then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expandable() or luasnip.locally_jumpable(-1) then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                }),
                completion = {
                    autocomplete = false
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" }
                }
                ),
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets"
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
}

return M
