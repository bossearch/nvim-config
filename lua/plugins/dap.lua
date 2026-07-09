return {
    {
        "nvim-dap",
        spec = { src = "https://github.com/mfussenegger/nvim-dap" },
        keys = {
            { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>dc", "<cmd>DapContinue<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>dt", "<cmd>DapViewToggle<cr>", mode = "n", noremap = true, silent = true },
            { "<leader>dv", "<cmd>DapViewVirtualTextToggle<cr>", mode = "n", noremap = true, silent = true },
        },
        before = function()
            require("lz.n").trigger_load("nvim-dap-view")
        end,
        after = function()
            local dap = require("dap")
            dap.adapters.codelldb = {
                type = "executable",
                command = vim.env.CODELLDB_PATH,
            }
            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.cpp = dap.configurations.c

            require("dap-view").setup({
                winbar = {
                    show = true,
                    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
                    controls = { enabled = true },
                },
            })
        end,
    },
    {
        "nvim-dap-view",
        spec = { src = "https://github.com/igorlfs/nvim-dap-view" },
        lazy = true,
    },
}
