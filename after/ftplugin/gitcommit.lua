vim.schedule(function()
    vim.opt_local.colorcolumn = { "50", "72" }
    vim.opt_local.comments = {
        "b:*",
        "b:-",
    }
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
    vim.opt_local.wrap = true
end)
