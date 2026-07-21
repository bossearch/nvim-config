local Mappings = {
    note_backlink = "<leader>nL",
    note_buffer = "<leader>nb",
    note_cd = ".n",
    note_find = "<leader>nf",
    note_link = "<leader>nl",
    note_new = "<leader>nn",
    note_new_content_select = "<leader>nc",
    note_new_title_select = "<leader>nt",
    note_tag = "<leader>nt",
}

local lz_keys = {}
for _, key_combo in pairs(Mappings) do
    table.insert(lz_keys, { key_combo })
end

return {
    "zk-nvim",
    spec = { src = "https://github.com/zk-org/zk-nvim" },
    keys = lz_keys,
    after = function()
        require("zk").setup({
            lsp = {
                config = {
                    name = "zk",
                    cmd = { "zk", "lsp" },
                    filetypes = { "markdown" },
                },

                auto_attach = {
                    enabled = true,
                },
            },
            tags = {
                multi_select_strategy = "AND", -- can be "AND" or "OR"
            },
            picker = "snacks_picker",
            picker_options = {
                snacks_picker = { layout = { preset = "full" } },
            },
        })
        local function map(mode, lhs, rhs, opts)
            vim.keymap.set(mode, lhs, rhs, opts)
        end
        local opts = { noremap = true, silent = false }

        local function zk_scope_tab(cmd)
            local notebook_dir = vim.env.ZK_NOTEBOOK_DIR
            local target_dir = vim.fn.fnamemodify(notebook_dir, ":p")
            local found_buf = nil

            -- buffer check
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    if vim.startswith(bufname, target_dir) then
                        found_buf = bufnr
                        break
                    end
                end
            end

            -- focus or create new tab
            if found_buf then
                local win_ids = vim.fn.win_findbuf(found_buf)
                if #win_ids > 0 then
                    vim.api.nvim_set_current_win(win_ids[1])
                else
                    vim.cmd("tabnew")
                    vim.api.nvim_set_current_buf(found_buf)
                end
            else
                vim.cmd("tabnew")
            end
            if cmd:match("^:'<,'>") then
                vim.cmd(cmd)
            else
                vim.cmd(cmd)
            end
        end

        map("n", Mappings.note_new, function()
            zk_scope_tab("ZkNew { title = '" .. vim.fn.input("Title: ") .. "' }")
        end, opts)

        map("v", Mappings.note_new_title_select, function()
            zk_scope_tab(":'<,'>ZkNewFromTitleSelection")
        end, opts)

        map("v", Mappings.note_new_content_select, function()
            zk_scope_tab(":'<,'>ZkNewFromContentSelection { title = '" .. vim.fn.input("Title: ") .. "' }")
        end, opts)

        map("n", Mappings.note_backlink, "<Cmd>ZkBacklinks<CR>", opts)
        map("n", Mappings.note_link, "<Cmd>ZkLinks<CR>", opts)
        map("n", Mappings.note_find, "<Cmd>ZkNotes<CR>", opts)
        map("n", Mappings.note_tag, "<Cmd>ZkTags<CR>", opts)
        map("n", Mappings.note_cd, "<Cmd>ZkCd<CR>", opts)
        map("n", Mappings.note_buffer, "<Cmd>ZkBuffers<CR>", opts)
    end,
}
