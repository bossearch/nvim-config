local opt = vim.opt

-- opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.cmdheight = 0
opt.colorcolumn = "80,120"
opt.conceallevel = 0
opt.confirm = true
opt.cursorline = true
opt.cursorlineopt = "number"
opt.expandtab = true
opt.fileencoding = 'utf-8'
opt.formatoptions:remove { 'c', 'r', 'o' }
opt.ignorecase = true
opt.inccommand = "split"
opt.iskeyword:append '-'
opt.linebreak = true
opt.list = true
opt.listchars = { tab = '» ', trail = '-', nbsp = '␣' }
opt.number = true
opt.numberwidth = 4
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 32
opt.shiftround = true
opt.shiftwidth = 4
opt.shortmess = opt.shortmess + "Ic"
opt.showmode = false
opt.sidescrolloff = 40
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 250
opt.whichwrap = 'bshl'
opt.wrap = false
opt.writebackup = false
