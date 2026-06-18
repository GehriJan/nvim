return {
  {
    dir = vim.fn.stdpath("config") .. "/pack/github/start/copilot.vim",
    name = "copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Use <M-l> to accept instead of <Tab> to avoid blink.cmp conflict
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<M-l>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Prev Copilot suggestion" })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
    end,
  },
}
