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

        map("n", Mappings.note_new, "<cmd>ZkNew {  title = vim.fn.input('Title: ') }<CR>", opts)
        map("v", Mappings.note_new_title_select, ":'<,'>ZkNewFromTitleSelection<CR>", opts)
        map(
            "v",
            Mappings.note_new_content_select,
            ":'<,'>ZkNewFromContentSelection { title = vim.fn.input('Title: ') }<CR>",
            opts
        )
        map("n", Mappings.note_backlink, "<Cmd>ZkBacklinks<CR>", opts)
        map("n", Mappings.note_link, "<Cmd>ZkLinks<CR>", opts)
        map("n", Mappings.note_find, "<Cmd>ZkNotes<CR>", opts)
        map("n", Mappings.note_tag, "<Cmd>ZkTags<CR>", opts)
        map("n", Mappings.note_cd, "<Cmd>ZkCd<CR>", opts)
        map("n", Mappings.note_buffer, "<Cmd>ZkBuffers<CR>", opts)
    end,
}
