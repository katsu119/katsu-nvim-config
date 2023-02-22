vim.g.mapleader = " "

local keymap = vim.keymap

-- Insert Keymap

-- Normal Keymap
keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>l", ":bnext<CR>")
keymap.set("n", "<leader>h", ":bprevious<CR>")


