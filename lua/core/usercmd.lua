local usercmd = vim.api.nvim_create_user_command

usercmd("CopyAbsolutePath", function()
    local path = vim.fn.expand("%:p")
require("lib.util").copy_to_clipboard(path) end, {})

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

-- Custom packer commands
usercmd("PackCheck", function()
    local non_active = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    if #non_active == 0 then
        vim.notify("🆗 No non-active plugins found!", vim.log.levels.INFO)
        return
    end

    vim.print("😴 Non-active plugins :")
    print(" ")
    for _, name in ipairs(non_active) do
        print(name)
    end

    print(" ")

    local choice = vim.fn.confirm(
        "Delete ALL non-active plugins from disk?",
        "&Yes\n&No",
        2 -- default = No
    )

    if choice == 1 then
        vim.pack.del(non_active)
        vim.notify("🗑️  Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
        print("Non-active plugins deleted!")
        vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
    else
        vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
    end
end, { desc = "List non active plugins and select to delete" })
