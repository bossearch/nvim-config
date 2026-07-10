local Mappings = {
    find_files = "<leader><leader>f",
    nvim_config = "<leader><leader>C",
    icons = "<leader><leader>.",
    commits = "<leader><leader>c",
    mappings = "<leader><leader>m",
    licenses = "<leader><leader>l",
    oldfiles = "<leader><leader>r",
    live_grep = "<leader><leader>g",
    grep_string = "<leader><leader>s",
    quickfix = "<leader><leader>q",
    help_tags = "<leader><leader>h",
    buffers = "<leader><leader>b",
    diagnostics = "<leader><leader>d",
    cmd_history = "<leader><leader>;",
    search_hist = "<leader><leader>/",
    registers = '<leader><leader>"',
    marks = "<leader><leader>'",
    highlights = "<leader><leader>H",
}

local lz_keys = {}
for _, key_combo in pairs(Mappings) do
    table.insert(lz_keys, { key_combo })
end

local ivy_opts = {
    layout_strategy = "ivy_flush",
    layout_config = { height = 0.6, prompt_position = "top", preview_cutoff = 0 },
}

local single_select_opts = {
    preview_title = false,
    selection_caret = "❯ ",
    entry_prefix = "  ",
    multi_icon = "",
    mappings = {
        i = {
            ["<CR>"] = function(bufnr)
                require("telescope.actions").select_default(bufnr)
            end,
            ["<Tab>"] = function() end,
            ["<S-Tab>"] = function() end,
        },
        n = {
            ["<CR>"] = function(bufnr)
                require("telescope.actions").select_default(bufnr)
            end,
            ["<Tab>"] = function() end,
            ["<S-Tab>"] = function() end,
        },
    },
}

local custom_picker_opts = {
    attach_mappings = function(_, map)
        map("i", "<Tab>", function() end)
        map("n", "<Tab>", function() end)
        map("i", "<S-Tab>", function() end)
        map("n", "<S-Tab>", function() end)
        return true
    end,
}

local function single_or_multi_select(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local action_utils = require("telescope.actions.utils")
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    if next(current_picker:get_multi_selection()) ~= nil then
        local results = {}
        action_utils.map_selections(prompt_bufnr, function(selection)
            table.insert(results, selection[1])
        end)
        for _, filepath in ipairs(results) do
            vim.cmd.badd({ args = { filepath } })
        end
        require("telescope.pickers").on_close_prompt(prompt_bufnr)
        if vim.fn.bufname() == "" and not vim.bo.modified then
            vim.cmd.bwipeout()
            vim.cmd.buffer(results[1])
        end
        return
    end
    require("telescope.actions").file_edit(prompt_bufnr)
end

return {
    {
        "telescope.nvim",
        spec = {
            src = "https://github.com/nvim-telescope/telescope.nvim",
            version = "master",
        },
        keys = lz_keys,
        before = function()
            require("lz.n").trigger_load("plenary.nvim")
            require("lz.n").trigger_load("telescope-fzf-native.nvim")
            require("lz.n").trigger_load("telescope-software-licenses.nvim")
        end,
        after = function()
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("software_licenses")
            require("lib._telescope.layout")

            local builtin = require("telescope.builtin")

            require("telescope").setup({
                defaults = vim.tbl_deep_extend("force", require("telescope.themes").get_ivy(ivy_opts), {
                    results_title = "",
                    prompt_prefix = "❯ ",
                    selection_caret = "○ ",
                    multi_icon = "● ",
                    entry_prefix = "○ ",
                }),
                pickers = {
                    find_files = {
                        preview_title = false,
                        follow = true,
                        hidden = true,
                        no_ignore = true,
                        file_ignore_patterns = { "^%.git/" },
                    },
                    live_grep = { preview_title = false },
                    quickfix = single_select_opts,
                    help_tags = single_select_opts,
                    buffers = single_select_opts,
                    diagnostics = single_select_opts,
                    command_history = single_select_opts,
                    search_history = single_select_opts,
                    highlights = single_select_opts,
                    registers = single_select_opts,
                    marks = single_select_opts,
                },
            })

            vim.keymap.set("n", Mappings.find_files, function()
                builtin.find_files({
                    attach_mappings = function(_, map)
                        map("i", "<cr>", single_or_multi_select)
                        map("n", "<cr>", single_or_multi_select)
                        return true
                    end,
                })
            end)

            vim.keymap.set("n", Mappings.nvim_config, function()
                builtin.find_files({
                    prompt_title = "Neovim Config",
                    cwd = vim.fn.stdpath("config"),
                    attach_mappings = function(_, map)
                        map("i", "<cr>", single_or_multi_select)
                        map("n", "<cr>", single_or_multi_select)
                        return true
                    end,
                })
            end)

            vim.keymap.set("n", Mappings.icons, function()
                require("lib._telescope").icons(vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_cursor({
                        layout_config = {
                            width = 60,
                            height = 12,
                        },
                    }),
                    single_select_opts,
                    custom_picker_opts
                ))
            end)

            vim.keymap.set("n", Mappings.commits, function()
                require("lib._telescope").commits(vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_cursor({
                        layout_config = {
                            width = 70,
                            height = 14,
                        },
                    }),
                    single_select_opts,
                    custom_picker_opts
                ))
            end)

            vim.keymap.set("n", Mappings.mappings, function()
                require("lib._telescope").mapping(
                    vim.tbl_deep_extend(
                        "force",
                        require("telescope.themes").get_ivy(ivy_opts),
                        single_select_opts,
                        custom_picker_opts
                    )
                )
            end)

            vim.keymap.set("n", Mappings.licenses, function()
                require("telescope").extensions.software_licenses.find(
                    vim.tbl_deep_extend(
                        "force",
                        require("telescope.themes").get_ivy(ivy_opts),
                        { prompt_title = "Software Licenses" },
                        single_select_opts,
                        custom_picker_opts
                    )
                )
            end)

            vim.keymap.set("n", Mappings.oldfiles, builtin.oldfiles)
            vim.keymap.set("n", Mappings.live_grep, builtin.live_grep)
            vim.keymap.set("n", Mappings.grep_string, builtin.grep_string)
            vim.keymap.set("n", Mappings.quickfix, builtin.quickfix)
            vim.keymap.set("n", Mappings.help_tags, builtin.help_tags)
            vim.keymap.set("n", Mappings.buffers, builtin.buffers)
            vim.keymap.set("n", Mappings.diagnostics, builtin.diagnostics)
            vim.keymap.set("n", Mappings.cmd_history, builtin.command_history)
            vim.keymap.set("n", Mappings.search_hist, builtin.search_history)
            vim.keymap.set("n", Mappings.registers, builtin.registers)
            vim.keymap.set("n", Mappings.marks, builtin.marks)
            vim.keymap.set("n", Mappings.highlights, builtin.highlights)
        end,
    },
    {
        "plenary.nvim",
        spec = { src = "https://github.com/nvim-lua/plenary.nvim" },
        lazy = true,
    },
    {
        "telescope-fzf-native.nvim",
        spec = { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
        lazy = true,
        after = function()
            local root = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
            if vim.fn.filereadable(root .. "/build/libfzf.so") == 0 then
                vim.fn.system({ "make", "-C", root })
            end
        end,
    },
    -- TODO: remove this use snippets instead same with commits
    {
        "telescope-software-licenses.nvim",
        spec = { src = "https://github.com/chip/telescope-software-licenses.nvim" },
        lazy = true,
    },
}
