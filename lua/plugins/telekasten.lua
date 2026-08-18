return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "renerocksai/calendar-vim",
  },
  opts = {
    home = vim.fn.expand("~/src/notes"), -- Change this to your notes directory
    -- Add any other custom settings here!
    -- external_link_follow = true,
    templates = vim.fn.expand("~/src/notes/templates"),
    -- Associate default templates for automatic note creation
    template_new_note = vim.fn.expand("~/src/notes/templates/new_note.md"),
    template_new_daily = vim.fn.expand("~/src/notes/templates/daily_note.md"),

    -- Calendar Integration settings
    plug_into_calendar = true,
    calendar_opts = {
      weeknm = 4,
      calendar_monday = 1,
      calendar_mark = "left-fit",
    },
  },
  keys = {
    -- Launch panel (the command palette) if nothing is typed after <leader>z
    { "<leader>z", "<cmd>Telekasten panel<cr>", desc = "Telekasten Panel" },
    -- Most used functions
    { "<leader>zf", "<cmd>Telekasten find_notes<cr>", desc = "Find Notes" },
    { "<leader>zg", "<cmd>Telekasten search_notes<cr>", desc = "Search Notes (Grep)" },
    { "<leader>zd", "<cmd>Telekasten goto_today<cr>", desc = "Go to Today's Note" },
    { "<leader>zz", "<cmd>Telekasten follow_link<cr>", desc = "Follow Link" },
    { "<leader>zn", "<cmd>Telekasten new_note<cr>", desc = "Create New Note" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<cr>", desc = "Show Calendar" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", desc = "Show Backlinks" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link<cr>", desc = "Insert Image Link" },
  },
}
