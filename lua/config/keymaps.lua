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

-- Insert Mode
vim.keymap.set("i", "kj", "<ESC>", { silent = true, desc = "Escape" })

-- Visual Mode
vim.keymap.set("v", "kj", "<ESC>", { silent = true, desc = "Escape Visual Mode" })
