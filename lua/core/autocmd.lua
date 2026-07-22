local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    return vim.api.nvim_create_augroup("user" .. name, { clear = true })
end

autocmd("TextYankPost", {
    group = augroup("highlight_on_yank"),
    pattern = "*",
    callback = function()
        vim.hl.on_yank()
    end,
})

autocmd("BufWritePre", {
    group = augroup("remove_trailing_whitespace_on_save"),
    pattern = "*",
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

autocmd("TermOpen", {
    group = augroup("custom_terminal"),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.statuscolumn = ""
        vim.opt_local.cursorline = false
        vim.b.miniindentscope_disable = true
    end,
})

autocmd({ "BufWritePre", "QuitPre" }, {
    group = augroup("kill_terminal"),
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
                vim.cmd("bdelete! " .. buf)
            end
        end
    end,
})

-- autocmd("User", {
--     group = augroup("run_alpha"),
--     pattern = "startuptime_loaded",
--     callback = function()
--         vim.schedule(function()
--             if vim.fn.argc() == 0 and vim.bo.filetype ~= "man" then
--                 vim.cmd("Alpha")
--             end
--         end)
--     end,
-- })
