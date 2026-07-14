local M = {}

M.keywords = {
    Todo = { "TODO" },
    Fix = { "FIX", "FIXME" },
    Hack = { "HACK" },
    Warn = { "WARN" },
    Perf = { "PERF" },
    Test = { "TEST" },
    Bug = { "BUG" },
    Note = { "NOTE" },
}

function M.setup_highlights(win_id)
    win_id = win_id or vim.api.nvim_get_current_win()
    if not vim.api.nvim_win_is_valid(win_id) then
        return
    end

    vim.api.nvim_win_call(win_id, function()
        for _, match in ipairs(vim.fn.getmatches()) do
            if match.group:match("Title$") or match.group:match("Entry$") then
                pcall(vim.fn.matchdelete, match.id)
            end
        end

        for type, words in pairs(M.keywords) do
            for _, word in ipairs(words) do
                local t_name = type .. "Title"
                local e_name = type .. "Entry"

                local title_pat = string.format([[\C\<%s\>:]], word)
                vim.fn.matchadd(t_name, title_pat, 12)

                local entry_pat = string.format([[\C\<%s\>:\s*\zs.*]], word)
                vim.fn.matchadd(e_name, entry_pat, 11)
            end
        end
    end)
end

function M.setup()
    local group = vim.api.nvim_create_augroup("custom_todo_matcher", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        group = group,
        pattern = "*",
        callback = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "snacks_picker_input" then
                return
            end
            M.setup_highlights(vim.api.nvim_get_current_win())
        end,
    })
end

M.setup()

return M
