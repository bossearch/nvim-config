return {
    "oil.nvim",
    spec = { src = "https://github.com/stevearc/oil.nvim" },
    keys = {
        {
            "<leader>e",
            "<cmd>lua require('oil').open(nil, { preview = {} })<cr>",
            mode = { "n" },
            noremap = true,
            silent = true,
            desc = "Open Oil",
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
                ["<C-f>"] = { "actions.preview_scroll_down", mode = "n" },
                ["<C-b>"] = { "actions.preview_scroll_up", mode = "n" },
            },
            use_default_keymaps = false,
        })

        local function augroup(name)
            return vim.api.nvim_create_augroup("user" .. name, { clear = true })
        end

        local function auto_delete_buffer()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if
                    vim.api.nvim_buf_is_valid(buf)
                    and vim.api.nvim_buf_is_loaded(buf)
                    and vim.bo[buf].buftype == ""
                    and vim.bo[buf].filetype ~= ""
                then
                    local name = vim.api.nvim_buf_get_name(buf)
                    if name ~= "" and not name:match("^%w+://") and not vim.uv.fs_stat(name) then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
            end
        end

        vim.api.nvim_create_autocmd("User", {
            group = augroup("auto_delete_buffer"),
            pattern = "OilActionsPost",
            callback = function()
                auto_delete_buffer()
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = augroup("toggle_columns"),
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
    end,
}
