local usercmd = vim.api.nvim_create_user_command

usercmd("CopyAbsolutePath", function()
    local path = vim.fn.expand("%:p")
    require("lib.util").copy_to_clipboard(path)
end, {})

usercmd("CopyAbsolutePathWithLine", function()
    local path = vim.fn.expand("%:p")
    local line = vim.fn.line(".")
    local result = path .. ":" .. line
    require("lib.util").copy_to_clipboard(result)
end, {})

usercmd("CopyRelativePath", function()
    local path = vim.fn.expand("%:~:p")
    require("lib.util").copy_to_clipboard(path)
end, {})

usercmd("CopyRelativePathWithLine", function()
    local path = vim.fn.expand("%:~:p")
    local line = vim.fn.line(".")
    local result = path .. ":" .. line
    require("lib.util").copy_to_clipboard(result)
end, {})
usercmd("CopyFileName", function()
    local path = vim.fn.expand("%:t")
    require("lib.util").copy_to_clipboard(path)
end, {})

usercmd("CopyFileNameWithLine", function()
    local path = vim.fn.expand("%:t")
    local line = vim.fn.line(".")
    local result = path .. ":" .. line
    require("lib.util").copy_to_clipboard(result)
end, {})

usercmd("LocalDir", function()
    local bufname = vim.fn.expand("%:p")
    if vim.fn.filereadable(bufname) == 0 then
        return
    end
    local file_dir = vim.fn.fnamemodify(bufname, ":h")
    vim.cmd("lcd " .. vim.fn.fnameescape(file_dir))
end, {})

usercmd("RootDir", function()
    local root = require("lib.util").get_root_dir()
    if root == "" then
        return
    end
    vim.cmd("lcd " .. root)
end, {})
