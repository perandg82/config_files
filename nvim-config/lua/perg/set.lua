vim.opt.guicursor = ""

vim.opt.statusline = "%F%m%r%h%w [FORMAT=%{&ff}] [TYPE=%Y] [POS=%04l,%04v][%p%%] [LEN=%L]"
vim.opt.laststatus = 2

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

