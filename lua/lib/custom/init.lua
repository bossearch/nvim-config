require("lib._alpha").get_startup_time()

-- lazy load customs
vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("lazy_load_custom_plugins", { clear = true }),
    callback = function(args)
        require("lib.custom.pack")
        if args.event == "UIEnter" then
            require("lib.custom.tmux")
        end
    end,
})
