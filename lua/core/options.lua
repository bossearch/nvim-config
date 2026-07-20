-- stylua: ignore start
local opt = vim.opt

-- core
opt.autoread = true        -- auto-reload changes if outside of neovim
opt.autowrite = false      -- do not auto-save
opt.fileencoding = "utf-8" -- file encoding format
opt.maxmempattern = 20000  -- increase max memory
opt.modifiable = true      -- allow buffer modifications
opt.timeoutlen = 500       -- key sequence timeout (ms)
opt.undofile = true        -- persistent undo enabled
opt.updatetime = 100       -- swap/write trigger delay (ms)
opt.writebackup = false    -- disable backup file creation
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- indenting
opt.expandtab = true  -- use spaces instead of tabs
opt.shiftround = true -- round indent to shiftwidth multiples
opt.shiftwidth = 2    -- size of each indent level
opt.softtabstop = 2   -- spaces inserted per Tab in insert mode
opt.tabstop = 2       -- visual width of a tab character

-- gutter and number
opt.foldcolumn = "0"      -- fold column
opt.number = true         -- show absolute line numbers
opt.numberwidth = 4       -- width reserved for line numbers
opt.relativenumber = true -- show relative line numbers
opt.signcolumn = "yes:1"  -- sign column
opt.statuscolumn = "%s%=%{v:virtnum>0?'':(v:relnum==0?v:lnum:v:relnum)} %C"

-- ui
opt.cmdheight = 0            -- minimal command line height
opt.colorcolumn = "80,120"   -- visual column guides
opt.conceallevel = 0         -- show concealed text normally
opt.cursorline = true        -- highlight current line
opt.cursorlineopt = "both"   -- highlight only line number area
opt.laststatus = 3           -- global statusline
opt.list = true              -- show invisible characters
opt.pumheight = 10           -- completion menu height
opt.shortmess:append("I")    -- reduce intro messages
opt.showmode = false         -- hide mode text (e.g. -- INSERT --)
opt.showtabline = 0          -- dont show tabline
opt.synmaxcol = 300          -- syntax highlighting limit
opt.termguicolors = true     -- enable true color support
opt.winborder = "none"       -- floating window border style
opt.winblend = 0             -- floating window transparency
opt.fillchars = { eob = " " }
opt.listchars = { tab = "» ", trail = "-", nbsp = "␣" }

-- behavior
opt.backspace = "indent,eol,start" -- better backspace behaviour
opt.confirm = true                 -- prompt before destructive actions
opt.iskeyword:append("-")          -- treat '-' as word character
opt.path:append("**")              -- include subdirs in search
opt.scrolloff = 999                -- keep x lines above/below cursor
opt.sidescrolloff = 10             -- keep x lines to left/right of cursor
opt.smartindent = true             -- automatic indentation rules
opt.smoothscroll = true            -- smooth scrolling behavior
opt.splitbelow = true              -- horizontal splits open below
opt.splitright = true              -- vertical splits open right
opt.whichwrap = "bshl"             -- allow cursor wrap across lines
opt.completeopt = { "menu", "menuone", "noinsert" }

-- fold
opt.foldenable = true   -- fold switch button
opt.foldlevel = 99      -- auto open indent
opt.foldlevelstart = 99 -- companien to foldlevel
opt.foldmethod = "expr" -- use expression for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- search
opt.ignorecase = true    -- case-insensitive search
opt.inccommand = "split" -- live preview for :substitute
opt.incsearch = true     -- show matches as you type
opt.smartcase = true     -- case-sensitive if uppercase used

-- wrap
opt.wrap = false     -- disable line wrapping
opt.linebreak = true -- wrap at word boundary when enabled
-- stylua: ignore end
