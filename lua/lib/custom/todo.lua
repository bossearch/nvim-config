local M = {}

M.match = {
    TodoTitle = [[\C\<TODO\s*:]],
    TodoEntry = [[\C\<TODO\s*:\s*\zs.*]],

    FixTitle = [[\C\<FIX\(ME\)\@!\s*:]],
    FixEntry = [[\C\<FIX\(ME\)\@!\s*:\s*\zs.*]],

    HackTitle = [[\C\<HACK\s*:]],
    HackEntry = [[\C\<HACK\s*:\s*\zs.*]],

    WarnTitle = [[\C\<WARN\s*:]],
    WarnEntry = [[\C\<WARN\s*:\s*\zs.*]],

    PerfTitle = [[\C\<PERF\s*:]],
    PerfEntry = [[\C\<PERF\s*:\s*\zs.*]],

    TestTitle = [[\C\<TEST\s*:]],
    TestEntry = [[\C\<TEST\s*:\s*\zs.*]],

    BugTitle = [[\C\<BUG\s*:]],
    BugEntry = [[\C\<BUG\s*:\s*\zs.*]],

    NoteTitle = [[\C\<NOTE\s*:]],
    NoteEntry = [[\C\<NOTE\s*:\s*\zs.*]],
}

function M.setup_highlights(win_id)
    local function apply()
        for hl_group, pattern in pairs(M.match) do
            vim.fn.matchadd(hl_group, pattern)
        end
    end

    if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_call(win_id, apply)
    else
        apply()
    end
end

M.setup_highlights()

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("todo_quickfix_hl", { clear = true }),
    callback = function()
        M.setup_highlights(vim.api.nvim_get_current_win())
    end,
})

return M
