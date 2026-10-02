local Mappings = {
    note_backlink = "<leader>nL",
    note_buffer = "<leader>nb",
    note_cd = ".n",
    note_find = "<leader>nf",
    note_index = "<leader>ni",
    note_link = "<leader>nl",
    note_new = "<leader>nn",
    note_new_content_select = "<leader>nN",
    note_new_title_select = "<leader>nn",
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
    ft = "markdown",
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
        map("n", Mappings.note_backlink, "<cmd>ZkBacklinks<CR>", opts)
        map("n", Mappings.note_buffer, "<cmd>ZkBuffers<CR>", opts)
        map("n", Mappings.note_cd, "<cmd>ZkCd<CR>", opts)
        map("n", Mappings.note_find, "<cmd>ZkNotes<CR>", opts)
        map("n", Mappings.note_index, "<cmd>ZkIndex<CR>", opts)
        map("n", Mappings.note_link, "<cmd>ZkLinks<CR>", opts)
        map("n", Mappings.note_tag, function()
            local zk_config = require("zk.config")
            zk_config.options.picker_options.snacks_picker.layout.preset = "ivy"
            require("zk.commands").get("ZkTags")()
            vim.defer_fn(function()
                zk_config.options.picker_options.snacks_picker.layout.preset = "full"
            end, 200)
        end, opts)
    end,
}
