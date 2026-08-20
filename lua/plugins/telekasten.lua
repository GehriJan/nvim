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
    { "<leader>zt", "<cmd>Telekasten new_templated_note<cr>", desc = "Create New Templated Note" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<cr>", desc = "Show Calendar" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", desc = "Show Backlinks" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link<cr>", desc = "Insert Image Link" },
    {
      "<leader>zm",
      function()
        vim.ui.input({ prompt = "Meeting Title: " }, function(input)
          if not input or input == "" then
            return
          end

          local home = vim.fn.expand("~/src/notes")
          local template_path = home .. "/templates/meetings_note.md"
          local date = os.date("%Y-%m-%d")
          local time = os.date("%H:%M")

          -- Clean title for filename: replace spaces with hyphens
          local clean_title = input:gsub("%s+", "-")
          local filename = date .. "-" .. clean_title .. ".md"
          local filepath = home .. "/meetings/" .. filename

          -- Read template content
          local template_file = io.open(template_path, "r")
          if not template_file then
            vim.notify("Could not open meeting template at " .. template_path, vim.log.levels.ERROR)
            return
          end
          local content = template_file:read("*a")
          template_file:close()

          -- Substitute variables
          local function safe_replace(str, placeholder, replacement)
            local escaped_replacement = replacement:gsub("%%", "%%%%")
            return str:gsub(placeholder, escaped_replacement)
          end

          content = safe_replace(content, "{{date}}", date)
          content = safe_replace(content, "{{time}}", time)
          content = safe_replace(content, "{{shorttitle}}", input)

          -- Write new note
          local file = io.open(filepath, "w")
          if not file then
            vim.notify("Could not create meeting note at " .. filepath, vim.log.levels.ERROR)
            return
          end
          file:write(content)
          file:close()

          -- Open the newly created note
          vim.cmd("edit " .. vim.fn.fnameescape(filepath))
        end)
      end,
      desc = "Create Meeting Note",
    },
  },
}
