-- The default leader key is "\", and it's best for me 
-- vim.g.mapleader = " "

local keymap = vim.keymap

-- Insert Keymap

-- Normal Keymap
keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>l", ":bnext<CR>")
keymap.set("n", "<leader>h", ":bprevious<CR>")

-- Outline
keymap.set("n", "<leader>o", ":SymbolsOutline<CR>")
