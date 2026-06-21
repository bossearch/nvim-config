local set = vim.keymap.set
local opt = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ";"
set({ "n", "v" }, "<space>", "<Nop>", opt)

-- clipboard
set({ "n", "v", "x" }, "y", '"+y', opt)
set("n", "yy", '"+yy', opt)
set("n", "Y", '"+Y', opt)
set("x", "p", [["_dP]], opt)

-- better up/down
set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- buffer navigation
set("n", "<S-Tab>", ":bprev<CR>", opt)
set("n", "<Tab>", ":bnext<CR>", opt)

-- move lines
set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", opt)
set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", opt)
set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opt)
set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opt)
set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", opt)
set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", opt)

-- better indent
set("v", "<", "<gv", opt)
set("v", ">", ">gv", opt)

-- join lines without moving cursor
set("n", "J", "mzJ`z", opt)

-- scroll in buffer with cursor centered
set("n", "<C-d>", "<C-d>zz", opt)
set("n", "<C-u>", "<C-u>zz", opt)

-- search result cursor centered
set("n", "n", "nzzzv", opt)
set("n", "N", "Nzzzv", opt)

-- replace word cursor is on globally
set({ "n", "v" }, "s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { noremap = true })

-- insert(i) auto indent
set("n", "i", function()
    if #vim.fn.getline(".") == 0 then
        return [["_cc]]
    else
        return "i"
    end
end, { expr = true })

-- dd dont yank blank line to registers
set("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end, { expr = true })

-- split
set("n", "-", "<C-W>s", opt)
set("n", "|", "<C-W>v", opt)

-- go to ? directory
set("n", "..", "<cmd>cd ..<cr>", opt)
set("n", "./", "<cmd>LocalDir<cr>", opt)
set("n", ".r", "<cmd>RootDir<cr>", opt)

-- sessions
set({ "n", "v", "i" }, "<C-s>", function()
    require("mini.sessions").write("global-session")
    print("Session saved!")
end, opt)

-- terminal
set("t", "<C-t>", "<cmd>close<cr>", opt)

-- hacky way to fix my typo when saving quiting
set({ "n", "v" }, "q:", ":q", opt)
set({ "n", "v" }, "q/", "<Nop>", opt)
set({ "n", "v" }, "q?", "<Nop>", opt)

-- sometime my keyboard have delay when switching layer
set("c", "<CR>", function()
    local cmd = vim.fn.getcmdline()
    if vim.fn.getcmdtype() == ':' then
        if cmd == '@' then return '<C-u>w<CR>' end
        if cmd == '@q' then return '<C-u>wq<CR>' end
        if cmd == '@qa' then return '<C-u>wqa<CR>' end
    end
    return '<CR>'
end, { expr = true, replace_keycodes = true })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open()
end, opt)
