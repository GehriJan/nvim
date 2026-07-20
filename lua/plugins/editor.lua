local exclude_patterns = {
  "**/.git/",
  "**/node_modules/",
  "**/.DS_Store",
}
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          exclude = exclude_patterns,
        },
        explorer = {
          hidden = true,
          exclude = exclude_patterns,
        },
      },
    },
  },
}
