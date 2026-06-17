return {
    "vim-startuptime",
    autoload = true,
    spec = {
        src = "https://github.com/dstein64/vim-startuptime",
    },
    after = function()
        vim.cmd("StartupTime --save saved_startuptime --hidden")
        local timer = vim.uv.new_timer()
        timer:start(10, 50, vim.schedule_wrap(function()
            if vim.g.saved_startuptime and vim.g.saved_startuptime.startup then
                timer:stop()
                timer:close()

                vim.api.nvim_exec_autocmds("User", {
                    pattern = "startuptime-loaded",
                })
            end
        end))
    end
}
