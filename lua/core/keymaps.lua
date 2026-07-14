local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ";"
map({ "n", "v" }, "<space>", "<Nop>", opts)
map("n", "<leader>rr", "<cmd>restart<CR>", opts)

-- clipboard
map("n", '"+y"+y', '"+Y', opts)
map("n", "D", '"+dd', opts)
map({ "n", "x" }, "D", '"+d', opts)
map("x", "p", [["_dP]], opts)

-- paste with indenting
map("n", "p", "p`[v`]=", opts)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- buffer navigation
map("n", "<S-h>", "<cmd>bprev<CR>", opts)
map("n", "<S-l>", "<cmd>bnext<CR>", opts)

-- tab navigation
map("n", "<Tab>n", "<cmd>tabnext<CR>", opts)
map("n", "<Tab>p", "<cmd>tabprev<CR>", opts)
map("n", "<Tab>q", "<cmd>tabclose<CR>", opts)
map("n", "<Tab>y", "<cmd>tabnew<CR>", opts)

-- terminal navigation
map("t", "<ESC>", [[<C-\><C-n>]], opts)
map("t", "<Tab>n", [[<C-\><C-n><Cmd>tabnext<CR>]], opts)
map("t", "<Tab>p", [[<C-\><C-n><Cmd>tabprevious<CR>]], opts)
map("t", "<Tab>q", [[<C-\><C-n><Cmd>tabclose<CR>]], opts)
map("t", "<Tab>y", [[<C-\><C-n><Cmd>tabnew<CR>]], opts)

-- open terminal
map("n", "<S-Tab>", function()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "terminal" then
                vim.api.nvim_set_current_tabpage(tab)
                vim.api.nvim_set_current_win(win)
                vim.cmd("startinsert")
                return
            end
        end
    end
    vim.cmd.tabnew()
    vim.cmd.term()
    vim.cmd.startinsert()
end, opts)

-- move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", opts)
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", opts)
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opts)
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opts)
map("v", "<A-j>", function()
    local count = vim.v.count1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)
    vim.cmd(string.format("'<,'>move '>+%d", count))
    vim.cmd("normal! gv=gv")
end, opts)
map("v", "<A-k>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)
    local count = vim.v.count1 + 1
    vim.cmd(string.format("'<,'>move '<-%d", count))
    vim.cmd("normal! gv=gv")
end, opts)

-- better indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- join lines without moving cursor
map("n", "J", "mzJ`z", opts)

-- scroll in buffer with cursor centered
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- search result cursor centered
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- replace word cursor is on globally
map({ "n", "v" }, "s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap = true })

-- insert(i) auto indent
map("n", "i", function()
    if #vim.fn.getline(".") == 0 then
        return [["_cc]]
    else
        return "i"
    end
end, { expr = true })

-- dd dont yank blank line to registers
map("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end, { expr = true })

-- split
map("n", "-", "<C-W>s", opts)
map("n", "|", "<C-W>v", opts)

-- go to ? directory
map("n", "..", "<cmd>cd ..<CR>", opts)
map("n", "./", "<cmd>CurrentDir<CR>", opts)
map("n", ".r", "<cmd>RootDir<CR>", opts)

-- Add undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- nohlsearch on escape
map({ "i", "n", "s" }, "<esc>", function()
    vim.cmd("noh")
    return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- hacky way to fix my typo when saving quiting
map({ "n", "v" }, "q:", "<cmd>q<CR>", opts)
map({ "n", "v" }, "q/", "<Nop>", opts)
map({ "n", "v" }, "q?", "<Nop>", opts)

-- sometime my keyboard have delay when switching layer
map("c", "<CR>", function()
    local cmd = vim.fn.getcmdline()
    if vim.fn.getcmdtype() == ":" then
        if cmd == "@" then
            return "<C-u>w<CR>"
        end
        if cmd == "@q" then
            return "<C-u>wq<CR>"
        end
        if cmd == "@qa" then
            return "<C-u>wqa<CR>"
        end
    end
    return "<CR>"
end, { expr = true, replace_keycodes = true })

-- native undotree
map("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, opts)

-- git conflict
map("n", "]x", [[/^<<<<<<<\|^=======\|^>>>>>>><CR>]], opts)
map("n", "[x", [[?^<<<<<<<\|^=======\|^>>>>>>><CR>]], opts)
