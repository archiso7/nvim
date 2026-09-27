-- Editor settings. No plugin dependencies.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.termguicolors = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitbelow = true
opt.splitright = true

opt.swapfile = false
opt.backup = false
opt.undofile = true
-- stdpath("state") is created by nvim; ~/.vim/undodir was not, so undofile
-- silently did nothing on a fresh machine.
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.updatetime = 250
opt.timeoutlen = 400
opt.autoread = true
opt.confirm = true
opt.mouse = "a"

-- Treat foo-bar as one word for gf / filename completion.
opt.isfname:append("@-@")

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
