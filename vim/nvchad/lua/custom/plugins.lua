local plugins = {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                -- go
                "go",
                "gomod",
                "gosum",
                -- python
                "python",
                -- web dev
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",
                "vue",
                -- vim
                "vim",
                "lua",
                -- other
                "ini",
                "json",
                "yaml",
                -- scripts
                "bash",
            },
        },
    },

    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                -- go
                "gopls",
                "golines",
                "gofumpt",
                "goimports-reviser",
                "delve",
                -- python
                "black",
                "debugpy",
                "mypy",
                "pyright",
                "ruff",
                -- bash
                "bash-language-server",
                "shfmt",
                -- lua
                "lua-language-server",
                "stylua",
                -- web
                "typescript-language-server",
                "vue-language-server",
                "prettier",
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        ft = {
            "go",
            "python",
            "lua",
            "sh",
            "bash",
            "ts",
            "js",
            "vue",
            "yaml",
            "yml",
            "json",
            "html",
            "css",
            "sass",
            "sql",
        },
        opts = function()
            return require("custom.configs.null-ls")
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    {
        "mfussenegger/nvim-dap",
        init = function()
            require("core.utils").load_mappings("dap")
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
            require("core.utils").load_mappings("dap_python")
        end,
    },

    {
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            require("dap-go").setup(opts)
            require("core.utils").load_mappings("dap_go")
        end,
    },

    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
            require("gopher").setup(opts)
            require("core.utils").load_mappings("gopher")
        end,
        build = function()
            vim.cmd([[silent! GoInstallDeps]])
        end,
    },

    {
        "bennypowers/splitjoin.nvim",
        keys = {
            {
                "gj",
                function()
                    require("splitjoin").join()
                end,
                desc = "Join the object under cursor",
            },
            {
                "g,",
                function()
                    require("splitjoin").split()
                end,
                desc = "Split the object under cursor",
            },
        },
    },
}

return plugins
