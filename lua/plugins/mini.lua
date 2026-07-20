return {
    "mini.nvim",
    spec = { src = "https://github.com/echasnovski/mini.nvim" },
    event = { "UiEnter" },
    after = function()
        local icons = require("mini.icons")
        icons.setup()
        icons.mock_nvim_web_devicons()

        require("mini.sessions").setup({
            autowrite = false,
            directory = vim.fn.stdpath("state") .. "/session",
            file = "",
            force = { delete = true, read = true, write = true },
            verbose = { read = true, write = true, delete = true },
        })
        vim.keymap.set({ "n", "v", "i" }, "<C-s>", function()
            require("mini.sessions").write("global-session")
        end, { noremap = true, silent = true })

        local function deferred_mini_modules()
            local ai = require("mini.ai")
            require("mini.ai").setup({
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                    u = ai.gen_spec.function_call(),
                },
            })
            require("mini.indentscope").setup({
                draw = {
                    delay = 10,
                    animation = require("mini.indentscope").gen_animation.none(),
                    priority = 2,
                },
                symbol = "│",
            })
            require("mini.comment").setup({
                options = {
                    custom_commentstring = function()
                        local ok, context_string = pcall(require, "ts_context_commentstring.internal")
                        if ok then
                            return context_string.calculate_commentstring() or vim.bo.commentstring
                        else
                            return vim.bo.commentstring
                        end
                    end,
                    ignore_blank_line = true,
                },
            })
            require("mini.diff").setup({
                view = {
                    style = "sign",
                    signs = { add = "+", change = "~", delete = "-" },
                    priority = 6,
                },
            })
            require("mini.splitjoin").setup({ mappings = { toggle = "Sj" } })
            require("mini.surround").setup()
            require("mini.align").setup()

            vim.keymap.set("n", "<leader>gh", ":!git restore --staged %<CR>")
            vim.keymap.set("n", "<leader>go", ":lua MiniDiff.toggle_overlay(0)<CR>")
        end

        local current_file = vim.api.nvim_buf_get_name(0)
        if current_file ~= "" then
            deferred_mini_modules()
        else
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                once = true,
                callback = function(args)
                    local ft = vim.bo[args.buf].filetype
                    if ft ~= "alpha" then
                        deferred_mini_modules()
                        return true
                    end
                end,
            })
        end
    end,
}
