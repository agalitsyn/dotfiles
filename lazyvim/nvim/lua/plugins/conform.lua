return {
  "stevearc/conform.nvim",
  opts = {
    ---@type table<string, conform.FormatterUnit[]>
    formatters_by_ft = {
      lua = { "stylua" },

      sh = { "shfmt" },

      go = { "goimports-reviser", "gofumpt", "golines" },

      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,

      javascript = { { "prettierd", "prettier" } },
    },
    formatters = {
      golines = {
        prepend_args = { "--max-len", "140" },
      },
    },
  },
}
