local M = {}
local util = require("lib.util")

function M.copy(mode, line1, line2)
    local relative_file = vim.fn.expand("%:.")
    local repo_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", ""):gsub("%.git$", "")
    if repo_url == "" then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return
    end

    -- Convert SSH git@github.com:user/repo to HTTPS url
    repo_url = repo_url:gsub("git@github%.com:", "https://github.com/")
    repo_url = repo_url:gsub("ssh://git@", "https://")

    local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
    if branch == "" then
        branch = vim.fn.system("git rev-parse --short HEAD"):gsub("\n", "")
    end

    local url = string.format("%s/blob/%s/%s", repo_url, branch, relative_file)

    if mode == "v" then
        local start_line = line1
        local end_line = line2

        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end

        if start_line == end_line then
            url = string.format("%s#L%d", url, start_line)
        else
            url = string.format("%s#L%d-L%d", url, start_line, end_line)
        end
    end

    util.copy_to_clipboard(url)
end

return M
