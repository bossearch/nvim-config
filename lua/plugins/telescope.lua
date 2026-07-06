return {
    {
        "telescope.nvim",
        spec = {
            src = "https://github.com/nvim-telescope/telescope.nvim",
            version = "master",
        },
        event = { "BufReadPre", "BufNewFile", "User AlphaLoaded" },
        -- TODO: move telescope keymap to keys
        -- keys = {},
        before = function()
            require("lz.n").trigger_load("plenary.nvim")
            require("lz.n").trigger_load("telescope-fzf-native.nvim")
            require("lz.n").trigger_load("telescope-software-licenses.nvim")
        end,
        after = function()
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("software_licenses")
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")

            -- multi open file
            local action_state = require("telescope.actions.state")
            local action_utils = require("telescope.actions.utils")
            local function single_or_multi_select(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local has_multi_selection = (next(current_picker:get_multi_selection()) ~= nil)

                if has_multi_selection then
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

            require("lib._telescope.layout")
            local ivy_opts = {
                layout_strategy = "ivy_flush",
                layout_config = {
                    height = 0.6,
                    prompt_position = "top",
                    preview_cutoff = 0,
                },
            }

            local single_select_opts = {
                preview_title = false,
                selection_caret = "",
                entry_prefix = "",
                multi_icon = "",
                mappings = {
                    i = {
                        ["<CR>"] = actions.select_default,
                        ["<Tab>"] = actions.nop,
                        ["<S-Tab>"] = actions.nop,
                    },
                    n = {
                        ["<CR>"] = actions.select_default,
                        ["<Tab>"] = actions.nop,
                        ["<S-Tab>"] = actions.nop,
                    },
                },
            }
            local single_or_multi_select_opts = {
                ---@diagnostic disable-next-line: unused-local
                attach_mappings = function(_prompt_bufnr, map)
                    map("i", "<cr>", single_or_multi_select)
                    map("n", "<cr>", single_or_multi_select)
                    return true
                end,
            }

            local custom_picker_opts = {
                ---@diagnostic disable-next-line: unused-local
                attach_mappings = function(_prompt_bufnr, map)
                    map("i", "<Tab>", actions.nop)
                    map("n", "<Tab>", actions.nop)
                    map("i", "<S-Tab>", actions.nop)
                    map("n", "<S-Tab>", actions.nop)
                    return true
                end,
            }

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
                        file_ignore_patterns = {
                            "^%.git/",
                        },
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

            vim.keymap.set("n", "<leader><leader>f", function()
                builtin.find_files({
                    attach_mappings = single_or_multi_select_opts.attach_mappings,
                })
            end)

            vim.keymap.set("n", "<leader><leader>C", function()
                builtin.find_files({
                    prompt_title = "Neovim Config",
                    cwd = vim.fn.stdpath("config"),
                    attach_mappings = single_or_multi_select_opts.attach_mappings,
                })
            end)

            vim.keymap.set("n", "<leader><leader>.", function()
                local icons_theme_opts = vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_cursor({
                        layout_config = {
                            width = 60,
                            height = 12,
                        },
                    }),
                    single_select_opts,
                    custom_picker_opts
                )
                require("lib._telescope").icons(icons_theme_opts)
            end)

            vim.keymap.set("n", "<leader><leader>c", function()
                local commits_theme_opts = vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_cursor({
                        layout_config = {
                            width = 70,
                            height = 14,
                        },
                    }),
                    single_select_opts,
                    custom_picker_opts
                )
                require("lib._telescope").commits(commits_theme_opts)
            end)

            vim.keymap.set("n", "<leader><leader>m", function()
                local mapping_theme_opts = vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_ivy(ivy_opts),
                    single_select_opts,
                    custom_picker_opts
                )
                require("lib._telescope").mapping(mapping_theme_opts)
            end)

            vim.keymap.set("n", "<leader><leader>l", function()
                local license_opts = vim.tbl_deep_extend(
                    "force",
                    require("telescope.themes").get_ivy(ivy_opts),
                    { prompt_title = "Software Licenses" },
                    single_select_opts,
                    custom_picker_opts
                )
                require("telescope").extensions.software_licenses.find(license_opts)
            end)
            -- project
            vim.keymap.set("n", "<leader><leader>r", builtin.oldfiles)
            vim.keymap.set("n", "<leader><leader>g", builtin.live_grep)
            vim.keymap.set("n", "<leader><leader>s", builtin.grep_string)
            -- lines
            vim.keymap.set("n", "<leader><leader>q", builtin.quickfix)
            vim.keymap.set("n", "<leader><leader>h", builtin.help_tags)
            vim.keymap.set("n", "<leader><leader>b", builtin.buffers)
            vim.keymap.set("n", "<leader><leader>d", builtin.diagnostics)
            -- notification
            vim.keymap.set("n", "<leader><leader>;", builtin.command_history)
            vim.keymap.set("n", "<leader><leader>/", builtin.search_history)
            vim.keymap.set("n", '<leader><leader>"', builtin.registers)
            vim.keymap.set("n", "<leader><leader>'", builtin.marks)
            -- zoxide
            vim.keymap.set("n", "<leader><leader>H", builtin.highlights)
        end,
    },
    {
        -- TODO: lazy load plenare
        "plenary.nvim",
        spec = { src = "https://github.com/nvim-lua/plenary.nvim" },
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
    {
        "telescope-software-licenses.nvim",
        spec = { src = "https://github.com/chip/telescope-software-licenses.nvim" },
        lazy = true,
    },
}
