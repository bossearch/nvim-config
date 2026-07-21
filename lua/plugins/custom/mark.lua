local mark_ns = vim.api.nvim_create_namespace("CustomMarkSigns")
vim.api.nvim_set_hl(0, "SignColumnMark", { link = "SpecialChar" })

local function update_mark_signs()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, mark_ns, 0, -1)
    local marks = vim.fn.getmarklist(bufnr)
    local global_marks = vim.fn.getmarklist()
    for _, m in ipairs(global_marks) do
        if m.pos[1] == bufnr then
            table.insert(marks, m)
        end
    end

    for _, m in ipairs(marks) do
        local mark_char = m.mark:sub(2, 2)
        if mark_char:match("%a") then
            local lnum = m.pos[2] - 1

            if lnum >= 0 then
                pcall(vim.api.nvim_buf_set_extmark, bufnr, mark_ns, lnum, 0, {
                    sign_text = mark_char,
                    sign_hl_group = "SignColumnMark",
                    priority = 10,
                })
            end
        end
    end
end

local marks_group = vim.api.nvim_create_augroup("CustomMarkSignsGroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = marks_group,
    callback = update_mark_signs,
})
