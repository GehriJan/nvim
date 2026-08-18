-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
-- Normal Mode
vim.keymap.set("n", "H", ":bprevious<CR>", { silent = true, desc = "Previous Buffer" })
vim.keymap.set("n", "L", ":bnext<CR>", { silent = true, desc = "Next Buffer" })
-- vim.keymap.set("n", ":<Leader>os", require("mini.starter").open, { desc = "Open mini starter" })

-- German Layout Adaptations
vim.keymap.set("n", "ä", "<C-]>", { desc = "Jump to definition" })
vim.keymap.set("n", "ö", "<C-[>", { desc = "Escape Normal Mode" })
vim.keymap.set("n", "Ä", "<C-o>", { desc = "Jump backward" })

-- Clipboard Shortcut
vim.keymap.set("v", "<C-y>", '"+y', { desc = "Copy to system clipboard" })

-- Search/Replace Word Under Cursor
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/]], { desc = "Replace word under cursor" })

-- Fast last active buffer toggle
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "Toggle last active buffer" })

-- Insert Mode
vim.keymap.set("i", "kj", "<ESC>", { silent = true, desc = "Escape" })

-- Visual Mode
vim.keymap.set("v", "kj", "<ESC>", { silent = true, desc = "Escape Visual Mode" })
