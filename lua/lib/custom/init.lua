require("lib._alpha").get_startup_time()

-- lazy load customs
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre", "UIEnter" }, {
    group = vim.api.nvim_create_augroup("lazy_load_custom_plugins", { clear = true }),
    callback = function(args)
        require("lib.custom.color") -- autoload colorscheme
        if args.event == "UIEnter" then
            require("lib.custom.pack")
            require("lib.custom.tmux")
        elseif args.event == "BufNewFile" or args.event == "BufReadPre" then
            require("lib.custom.todo")
        end
    end,
})
