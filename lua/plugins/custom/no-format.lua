local function run_without_format(cmd)
    vim.b.disable_autoformat = true
    local success, err = pcall(function()
        vim.cmd(cmd)
    end)

    vim.b.disable_autoformat = false

    if not success then
        vim.api.nvim_echo({ { err, "ErrorMsg" } }, true, {})
    end
end

local commands = {
    W = "write",
    Wa = "wall",
    Wq = "wq",
    Wqa = "wqa",
}

for cmd_name, vim_cmd in pairs(commands) do
    vim.api.nvim_create_user_command(cmd_name, function(opts)
        local final_cmd = vim_cmd .. (opts.bang and "!" or "")
        run_without_format(final_cmd)
    end, { bang = true, desc = "Save/Quit without running autoformat" })
end
