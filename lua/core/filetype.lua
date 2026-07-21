vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("lazy_load_filetype", { clear = true }),
    callback = function(args)
        vim.filetype.add({
            extension = { vpy = "python" },
            pattern = {
                [".*/hypr/.*%.conf"] = "hyprlang",
            },
        })
        vim.api.nvim_del_augroup_by_id(args.group)
    end,
})
