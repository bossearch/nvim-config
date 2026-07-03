local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    return vim.api.nvim_create_augroup("user" .. name, { clear = true })
end

autocmd("TextYankPost", {
    group = augroup("highlight_on_yank"),
    pattern = { "*" },
    callback = function()
        vim.hl.on_yank()
    end,
})

autocmd("BufWritePre", {
    group = augroup("remove_trailing_whitespace_on_save"),
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        pcall(function()
            vim.cmd([[%s/\s\+$//e]])
        end)
        vim.fn.setpos(".", save_cursor)
    end,
})

autocmd("VimResized", {
    group = augroup("resize_splits_on_window_resize"),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

autocmd("BufWritePre", {
    group = augroup("auto_create_directory_before_saving_file"),
    callback = function(event)
        local file = vim.uv.fs_realpath(event.match) or event.match
        if vim.bo.filetype == "oil" then
            return
        end
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

autocmd("CursorMoved", {
    group = augroup("auto_nohlsearch"),
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd("nohlsearch")
            end)
        end
    end,
})

autocmd("FileType", {
    group = augroup("formatoptions"),
    pattern = "*",
    callback = function(args)
        vim.opt_local.formatoptions:remove("r")
        vim.opt_local.formatoptions:remove("o")
        if vim.tbl_contains({ "markdown", "gitcommit" }, args.match) then
            vim.opt_local.formatoptions:append("r")
            vim.opt_local.formatoptions:append("o")
            vim.opt_local.spell = true
        end
    end,
})
autocmd("User", {
    group = augroup("startuptime-loaded"),
    pattern = "startuptime-loaded",
    callback = function()
        vim.cmd("Alpha")
    end,
})
