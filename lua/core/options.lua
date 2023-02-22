local opt = vim.opt

-- Line Number
opt.relativenumber = true
opt.number = true

-- Indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- wrap off
opt.wrap = false

opt.cursorline = true
opt.scrolloff = 3

-- Enable mouse
opt.mouse:append("a")

-- Enable system clipboard
opt.clipboard:append("unnamedplus")

-- default windows position
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Appearence
opt.termguicolors = true
opt.signcolumn = "yes"

vim.cmd([[colorscheme tokyonight-moon]])
