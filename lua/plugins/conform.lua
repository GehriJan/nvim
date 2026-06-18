return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      xml = { "xmlformat" },
      json = { "prettierd", "prettier", stop_after_first = true }, -- Tries prettierd first, falls back to prettier
      yaml = { "yamlfmt" },
      html = { "prettier" },
      lua = { "stylua" },
      python = { "ruff" },
    },
  },
}
