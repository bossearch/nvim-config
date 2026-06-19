local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
    pattern = { "*" },
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        pcall(function()
            vim.cmd([[%s/\s\+$//e]])
        end)
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Resize splits on window resize
autocmd("VimResized", {
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Auto-create directory before saving file
autocmd("BufWritePre", {
    callback = function(event)
        local file = vim.uv.fs_realpath(event.match) or event.match
        if vim.bo.filetype == "oil" then
            return
        end
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
