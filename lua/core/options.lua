local opt = vim.opt

-- core
opt.fileencoding = "utf-8" -- file encoding format
opt.timeoutlen = 200       -- key sequence timeout (ms)
opt.undofile = true        -- persistent undo enabled
opt.updatetime = 100       -- swap/write trigger delay (ms)
opt.writebackup = false    -- disable backup file creation
opt.undodir = vim.fn.stdpath("data") .. "/undofile"

-- indenting
opt.expandtab = true  -- use spaces instead of tabs
opt.shiftround = true -- round indent to shiftwidth multiples
opt.shiftwidth = 4    -- size of each indent level
opt.softtabstop = 4   -- spaces inserted per Tab in insert mode
opt.tabstop = 4       -- visual width of a tab character

-- gutter and number
opt.number = true           -- show absolute line numbers
opt.numberwidth = 4         -- width reserved for line numbers
opt.relativenumber = true   -- show relative line numbers
opt.signcolumn = "auto:1-2" -- sign column
opt.statuscolumn = "%s%=%{v:virtnum>0?'':(v:relnum==0?v:lnum:v:relnum)} %C"

-- ui
opt.cmdheight = 0            -- minimal command line height
opt.colorcolumn = "80,120"   -- visual column guides
opt.conceallevel = 0         -- show concealed text normally
opt.cursorline = true        -- highlight current line
opt.cursorlineopt = "number" -- highlight only line number area
opt.laststatus = 3           -- global statusline
opt.list = true              -- show invisible characters
opt.pumheight = 10           -- completion menu height
opt.shortmess:append("I")    -- reduce intro messages
opt.showmode = false         -- hide mode text (e.g. -- INSERT --)
opt.termguicolors = true     -- enable true color support
opt.winborder = "none"       -- floating window border style
opt.listchars = { tab = "» ", trail = "-", nbsp = "␣" }

-- behavior
opt.confirm = true        -- prompt before destructive actions
opt.iskeyword:append("-") -- treat '-' as word character
opt.smartindent = true    -- automatic indentation rules
opt.smoothscroll = true   -- smooth scrolling behavior
opt.splitbelow = true     -- horizontal splits open below
opt.splitright = true     -- vertical splits open right
opt.whichwrap = "bshl"    -- allow cursor wrap across lines
opt.scrolloff = 8         -- keep 8 lines visible around cursor

-- fold
opt.foldcolumn = "auto:1" -- fold column
opt.foldenable = false    -- fold switch button
opt.foldlevel = 99        -- auto open indent
opt.foldlevelstart = 99   -- companien to foldlevel
opt.foldmethod = "indent"

-- search
opt.ignorecase = true    -- case-insensitive search
opt.inccommand = "split" -- live preview for :substitute
opt.smartcase = true     -- case-sensitive if uppercase used

-- wrap
opt.wrap = false     -- disable line wrapping
opt.linebreak = true -- wrap at word boundary when enabled
