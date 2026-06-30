return {
    "mini.nvim",
    spec = { src = "https://github.com/echasnovski/mini.nvim" },
    event = { "UiEnter" },
    after = function()
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
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
                predicate = function(scope)
                    return not scope.body.is_incomplete
                end,
                priority = 2,
            },
            mappings = {
                object_scope = "ii",
                object_scope_with_border = "ai",
                goto_top = "[i",
                goto_bottom = "]i",
            },
            options = {
                border = "both",
                indent_at_cursor = false,
                n_lines = 10000,
                try_as_border = false,
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
                start_of_line = false,
                pad_comment_parts = true,
            },
            mappings = {
                comment = "gc",
                comment_line = "gcc",
                comment_visual = "gc",
                textobject = "gc",
            },
        })
        require("mini.diff").setup({
            view = {
                style = "sign",
                signs = { add = "+", change = "~", delete = "-" },
                priority = 6,
            },
            source = nil,
            delay = {
                text_change = 200,
            },
            mappings = {
                apply = "gh",
                reset = "gH",
                textobject = "gh",
                goto_first = "",
                goto_prev = "[h",
                goto_next = "]h",
                goto_last = "",
            },
            options = {
                algorithm = "histogram",
                indent_heuristic = true,
                linematch = 60,
                wrap_goto = false,
            },
        })
        require("mini.sessions").setup({
            autoread = false,
            autowrite = false,
            directory = vim.fn.stdpath("state") .. "/session",
            file = "",
            force = { delete = true, read = true, write = true },
            hooks = {
                post = {
                    read = function(data)
                        vim.schedule(function()
                            vim.notify(data.name .. " restored")
                        end)
                    end,
                    write = nil,
                    delete = nil,
                },
                pre = { read = nil, write = nil, delete = nil },
            },
            verbose = { delete = true, read = false, write = true },
        })
        require("mini.splitjoin").setup({ mappings = { toggle = "Sj" } })
        require("mini.surround").setup()

        vim.keymap.set("n", "<leader>gh", ":!git restore --staged %<CR>")
        vim.keymap.set("n", "<leader>gd", ":lua MiniDiff.toggle_overlay(0)<CR>")
        vim.keymap.set({ "n", "v", "i" }, "<C-s>", function()
            require("mini.sessions").write("global-session")
        end, { noremap = true, silent = true })
    end,
}
