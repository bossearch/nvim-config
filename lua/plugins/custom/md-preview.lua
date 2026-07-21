local function start()
    if vim.bo.filetype ~= "markdown" then
        vim.notify("MDPreview: Current file is not a Markdown file", vim.log.levels.WARN)
        return
    end

    local file_path = vim.api.nvim_buf_get_name(0)
    if file_path == "" then
        vim.notify("MDPreview: File must be saved first", vim.log.levels.ERROR)
        return
    end

    local cmd = { "gh", "markdown-preview", file_path }

    -- async?
    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
            if exit_code ~= 0 then
                vim.notify("MDPreview: Failed to run 'gh preview-markdown'", vim.log.levels.ERROR)
            else
                vim.notify("MDPreview: Preview started successfully", vim.log.levels.INFO)
            end
        end,
    })
end

return start()
