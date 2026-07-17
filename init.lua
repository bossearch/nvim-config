vim.loader.enable()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lib.util").scan_modules("lua/core", "core.")

require("plugins")
