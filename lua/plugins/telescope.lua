return {
    "telescope.nvim",
    spec = {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        version = "master",
        dependencies = {
            "https://github.com/nvim-lua/plenary.nvim",
        }
    },
    event = { "BufReadPre", "BufNewFile", "User AlphaLoaded" },
    after = function()
        local builtin = require('telescope.builtin')
        require('telescope').setup({
            defaults = vim.tbl_deep_extend(
                "force",
                require("telescope.themes").get_ivy(),
                {
                    layout_config = {
                        height = 0.5,
                        prompt_position = "top",
                        preview_cutoff = 0,
                    },
                    prompt_prefix = "❯ ",
                    selection_caret = "",
                    entry_prefix = "",
                    results_title = "",
                }
            ),
            vim.keymap.set('n', '<leader><leader>b', builtin.buffers),
            vim.keymap.set('n', '<leader><leader>r', builtin.oldfiles),
            vim.keymap.set('n', '<leader><leader>:', builtin.command_history),
            vim.keymap.set('n', '<leader><leader>/', builtin.search_history),
            vim.keymap.set('n', '<leader><leader>"', builtin.registers),
            vim.keymap.set('n', '<leader><leader>H', builtin.highlights),
            vim.keymap.set('n', '<leader><leader>f', builtin.find_files),
            vim.keymap.set('n', '<leader><leader>w', builtin.live_grep),
            vim.keymap.set('n', '<leader><leader>h', builtin.help_tags),
            vim.keymap.set('n', '<leader><leader>gs', builtin.git_status),
            vim.keymap.set('n', '<leader><leader>gc', builtin.git_commits),
        })
    end
}
