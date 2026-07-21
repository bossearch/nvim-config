local autocmd = vim.api.nvim_create_autocmd
local tab_buffer_cache = {}
local tab_scope_group = vim.api.nvim_create_augroup("TabBufferScope", { clear = true })

local function initialize_current_tab()
    local current_tab = vim.api.nvim_get_current_tabpage()
    tab_buffer_cache[current_tab] = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
            table.insert(tab_buffer_cache[current_tab], buf)
        end
    end
end

autocmd("TabLeave", {
    group = tab_scope_group,
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        tab_buffer_cache[current_tab] = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
                table.insert(tab_buffer_cache[current_tab], buf)
                vim.bo[buf].buflisted = false
            end
        end
    end,
})

autocmd("TabEnter", {
    group = tab_scope_group,
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        local tab_buffers = tab_buffer_cache[current_tab] or {}
        for _, buf in ipairs(tab_buffers) do
            if vim.api.nvim_buf_is_valid(buf) then
                vim.bo[buf].buflisted = true
            end
        end
    end,
})

autocmd("TabClosed", {
    group = tab_scope_group,
    callback = function()
        local valid_tabs = {}
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            valid_tabs[tab] = true
        end

        for tab_id, buffers in pairs(tab_buffer_cache) do
            if not valid_tabs[tab_id] then
                for _, buf in ipairs(buffers) do
                    if vim.api.nvim_buf_is_valid(buf) then
                        pcall(vim.api.nvim_buf_delete, buf, { force = true })
                    end
                end
                tab_buffer_cache[tab_id] = nil
            end
        end
    end,
})

initialize_current_tab()
