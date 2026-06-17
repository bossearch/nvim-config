vim.loader.enable()

vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- load module from lua
local target_dirs = { "plugins", "core" }
local config_dir = vim.fn.stdpath("config")
for _, dir_name in ipairs(target_dirs) do
    local full_path = config_dir .. "/lua/" .. dir_name
    if vim.fn.isdirectory(full_path) == 1 then
        for name, type in vim.fs.dir(full_path) do
            if type == "file" and name:match("%.lua$") then
                local module = dir_name .. "." .. name:gsub("%.lua$", "")
                require(module)
            end
        end
    end
end
