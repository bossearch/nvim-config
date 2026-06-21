return {
    "oil.nvim",
    spec = { src = "https://github.com/stevearc/oil.nvim" },
    auoload = true,
    cmd = "Oil",
    keys = {
        {
            "<leader>o",
            "<cmd>lua require('oil').open(nil, { preview = {} })<cr>",
            mode = { "n" },
            noremap = true,
            silent = true
        },
    },
    after = function()
        local detail = false
        local icon = true
        require("oil").setup({
            columns = { "icon" },
            default_file_explorer = true,
            view_options = {
                show_hidden = true,
            },
            delete_to_trash = true,
            skip_confirm_for_simple_edits = false,
            preview_win = {
                update_on_cursor_moved = true,
                preview_method = "fast_scratch",
                disable_preview = function(filename)
                    local file_size = vim.fn.getfsize(filename)
                    return file_size > 100 * 1024
                end,
                win_options = {
                    wrap = false,
                    signcolumn = "no",
                    cursorcolumn = false,
                    foldcolumn = "0",
                    spell = false,
                    list = false,
                    -- foldmethod = "indent",
                },
            },
            keymaps = {
                ["g?"] = { "actions.show_help", mode = "n" },
                ["<CR>"] = "actions.select",
                ["|"] = { "actions.select", opts = { vertical = true } },
                ["-"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = { "actions.close", mode = "n" },
                [".."] = { "actions.parent", mode = "n" },
                ["gr"] = "actions.refresh",
                ["gt"] = { "actions.toggle_trash", mode = "n" },
                ["H"] = { "actions.preview_scroll_left", mode = "n" },
                ["J"] = { "actions.preview_scroll_down", mode = "n" },
                ["K"] = { "actions.preview_scroll_up", mode = "n" },
                ["L"] = { "actions.preview_scroll_right", mode = "n" },
            },
            use_default_keymaps = false,
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil",
            callback = function()
                vim.keymap.set("n", "gd", function()
                    detail = not detail
                    if detail then
                        require("oil").set_columns({ "icon", "size", "mtime" })
                    else
                        require("oil").set_columns({ "icon" })
                    end
                    vim.cmd("normal 0")
                end, { buffer = true })
                vim.keymap.set("n", "gi", function()
                    icon = not icon
                    if icon then
                        vim.cmd("set foldcolumn=0")
                        require("oil").set_columns({ "icon" })
                    else
                        vim.cmd("set foldcolumn=3")
                        require("oil").set_columns({})
                    end
                    vim.cmd("normal 0")
                end, { buffer = true })
            end,
        })
    end
}
