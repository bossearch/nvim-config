require("vim._core.ui2").enable({
    enable = true,
    msg = {
        targets = "msg",
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.5,
            timeout = 1000,
        },
        pager = {
            height = 0.5,
        },
    },
})

local augroup = vim.api.nvim_create_augroup("hide_lualine", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = augroup,
    pattern = { ":", "/", "?" },
    callback = function()
        vim.opt.laststatus = 0
        local window = require("lib.util").get_window()
        if #window > 1 then
            if package.loaded["lualine"] then
                pcall(function()
                    require("lualine").hide({ place = { "statusline" } })
                end)
            end
            local width = vim.api.nvim_win_get_width(0)
            vim.opt.statusline = string.rep("─", width)
        end
    end,
})

vim.api.nvim_create_autocmd("CmdlineLeavePre", {
    group = augroup,
    pattern = { ":", "/", "?" },
    callback = function()
        vim.schedule(function()
            vim.opt.laststatus = 3
            local window = require("lib.util").get_window()
            if #window > 1 then
                if package.loaded["lualine"] then
                    pcall(function()
                        require("lualine").hide({ unhide = true, place = { "statusline" } })
                    end)
                end
                vim.opt.statusline = nil
            end
        end)
    end,
})
