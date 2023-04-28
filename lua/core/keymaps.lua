-- The default leader key is "\", and it's best for me 
-- vim.g.mapleader = " "

local keymap = vim.keymap

-- Insert Keymap

-- Normal Keymap
keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>]", ":bnext<CR>")
keymap.set("n", "<leader>[", ":bprevious<CR>")

-- keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- keymap.set("t", "<C-v><Esc>", "<Esc>")

