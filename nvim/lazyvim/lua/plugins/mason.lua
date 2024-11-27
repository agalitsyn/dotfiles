return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",

        "shellcheck",
        "shfmt",

        "ruff",
        "isort",
        "black",
        "pyright",
        "mypy",

        "prettier",
        "prettierd",
        "typescript-language-server",
        "vue-language-server",

        "goimports-reviser",
        "gofumpt",
        "golines",
        "gopls",
        "delve",
        "golangci-lint",
        "gotests",

        "elixir-ls",
      },
    },
  },
}
