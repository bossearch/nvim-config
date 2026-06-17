vim.loader.enable()

vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

local extra_dirs = { "core", "lib" }
local config_dir = vim.fn.stdpath("config")
for _, dir_name in ipairs(extra_dirs) do
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

vim.pack.add({ "https://github.com/lumen-oss/lz.n" }, { confirm = false })

local lz_table = {}
local pack_table = {}
local plugins_dir = config_dir .. "/lua/plugins"

for name, type in vim.fs.dir(plugins_dir) do
	if type == "file" and name:match("%.lua$") then
		local plugin = require("plugins." .. name:gsub("%.lua$", ""))

		if plugin.spec then
			table.insert(pack_table, plugin.spec)
			plugin.spec = nil
		end

		table.insert(lz_table, plugin)
	end
end

vim.pack.add(pack_table, { confirm = false })
require("lz.n").load(lz_table)
-- print("=== pack_table ===")
-- print(vim.inspect(pack_table))
-- print("=== lz_table ===")
-- print(vim.inspect(lz_table))
