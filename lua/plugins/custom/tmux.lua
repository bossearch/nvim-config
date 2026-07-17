local function tmux_navigate(direction)
    local winnr = vim.fn.winnr()
    vim.cmd("wincmd " .. direction)
    if winnr == vim.fn.winnr() and vim.env.TMUX then
        local tmux_dir = { h = "L", j = "D", k = "U", l = "R" }
        vim.fn.system("tmux select-pane -" .. tmux_dir[direction])
    end
end

for _, dir in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set({ "n", "v", "i", "x" }, "<C-" .. dir .. ">", function()
        tmux_navigate(dir)
    end, {
        silent = true,
        desc = "Navigate " .. dir,
    })

    vim.keymap.set("t", "<C-" .. dir .. ">", function()
        vim.cmd("stopinsert")
        tmux_navigate(dir)
    end, {
        silent = true,
        desc = "Navigate " .. dir .. " (terminal)",
    })
end
