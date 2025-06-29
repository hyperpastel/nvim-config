local M = {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- C / C++: clangd
            -- Python: Ruff for {formatting, linting, organising imports}, Pylsp for completions
            -- Lua: lua_ls with lazydev
            -- LaTeX: texlab
            -- Nix: nixd
            -- Spellchecking: typos_lsp

            local servers = { "clangd", "ruff", "pylsp", "lua_ls", "texlab", "nixd", "typos_lsp", "jdtls", "c3_lsp" }
            for _, server in ipairs(servers) do
                vim.lsp.enable(server)
            end

            vim.lsp.config("pylsp", {
                settings = {
                    pylsp = {
                        -- Ruff does this for us but faster
                        plugins = {
                            autopep8 = { enabled = false },
                            mccabe = { enabled = false },
                            preload = { enabled = false },
                            pycodestyle = { enabled = false },
                        },
                    },
                },
            })

			-- This is needed on nix, since nixpkgs provides the executable as c3-lsp,
			-- while upstream uses a build script and generates it as 'c3lsp'
			--
			-- I am currently working on a PR that introduces a Justfile and fixes this
			-- discrepancy
			vim.lsp.config("c3_lsp", {
				cmd = { "c3-lsp" }
			})

            vim.lsp.config("nixd", {
                settings = {
                    nixd = {
                        formatting = {
                            command = {
                                "nixfmt"
                            }
                        }
                    }
                }
            })

            -- Make the diagnostics pretty!!
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "🌺",
                        [vim.diagnostic.severity.WARN] = "🌻",
                        [vim.diagnostic.severity.INFO] = "🍇",
                        [vim.diagnostic.severity.HINT] = "🫐",
                    },
                },
            })

            vim.lsp.inlay_hint.enable()

            local set = vim.keymap.set
            local bufopts = { noremap = true, silent = true }

            -- In the future, we might add more of rustaceanvims functionality
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    if client ~= nil and client.name == "rust_analyzer" then
                        set("n", "K", function()
                            vim.cmd.RustLsp({ "hover", "actions" })
                        end, bufopts)
                        set("n", "<leader>a", function()
                            vim.cmd.RustLsp("codeAction")
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
                end,
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                -- mypy: Static type analysis for Python
                python = { "mypy" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            handler_opts = {
                border = "rounded",
            },
            hint_prefix = "🌈 ",
            floating_window = false,
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    default_settings = {
                        ["rust_analyzer"] = {
                            check = { command = "clippy" },
                        },
                    },
                },
            }
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}

return M
