return {
    "blink.cmp",
    spec = {
        src = "https://github.com/saghen/blink.cmp",
        version = "v1",
        dependencies = {
            "https://github.com/Kaiser-Yang/blink-cmp-git",
            "https://github.com/archie-judd/blink-cmp-words",
            "https://github.com/mikavilpas/blink-ripgrep.nvim",
        },
    },
    event = "InsertEnter",
    after = function()
        require("blink-cmp").setup({
            appearance = {
                kind_icons = {
                    Class = "",
                    Color = "",
                    Constant = "",
                    Constructor = "",
                    Copilot = "",
                    Enum = "",
                    EnumMember = "",
                    Event = "",
                    Field = "",
                    File = "",
                    Folder = "",
                    Function = "󰊕",
                    Interface = "",
                    Keyword = "",
                    Method = "",
                    Module = "󱒌",
                    Operator = "",
                    Property = "",
                    Reference = "",
                    Snippet = "",
                    Struct = "",
                    Text = "",
                    TypeParameter = "",
                    Unit = "",
                    Value = "",
                    Variable = "",
                    Warning = "",
                },
                nerd_font_variant = "normal",
            },
            cmdline = {
                completion = {
                    list = { selection = { auto_insert = true, preselect = true } },
                    menu = { auto_show = true },
                },
                enabled = true,
                keymap = { preset = "inherit" },
                sources = function()
                    local type = vim.fn.getcmdtype()
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" or type == "@" then
                        return { "cmdline" }
                    end
                    return {}
                end,
            },
            completion = {
                accept = { auto_brackets = { enabled = false } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                ghost_text = { enabled = false },
                list = { selection = { auto_insert = true, preselect = true } },
                menu = {
                    auto_show = true,
                    draw = {
                        columns = { { "label", "label_description", gap = 1 }, { "kind", gap = 1, "kind_icon" } },
                        padding = { 1, 0 },
                    },
                },
            },
            keymap = {
                preset = "none",
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-y>"] = { "select_and_accept", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                ["<Tab>"] = { "snippet_forward", "fallback" },
            },
            signature = { enabled = false },
            -- snippets = { preset = "luasnip" },
            sources = {
                default = { "buffer", "dictionary", "lsp", "git", "path", "ripgrep", "snippets", "thesaurus" },
                providers = {
                    buffer = {
                        async = true,
                        enabled = true,
                        max_items = 4,
                        min_keyword_length = 2,
                        module = "blink.cmp.sources.buffer",
                        name = "buff",
                        opts = {
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                        },
                        score_offset = 60,
                    },
                    dictionary = {
                        enabled = function()
                            return vim.tbl_contains({ "gitcommit", "markdown" }, vim.bo.filetype)
                        end,
                        module = "blink-cmp-words.dictionary",
                        name = "dict",
                        opts = {
                            definition_pointers = { "!", "&", "^" },
                            dictionary_search_threshold = 3,
                            score_offset = 40,
                        },
                    },
                    git = {
                        enabled = function()
                            return vim.tbl_contains({ "gitcommit" }, vim.bo.filetype)
                        end,
                        min_keyword_length = 1,
                        module = "blink-cmp-git",
                        name = "git",
                        score_offset = 90,
                    },
                    lsp = {
                        async = true,
                        enabled = true,
                        fallbacks = { "buffer" },
                        min_keyword_length = 0,
                        module = "blink.cmp.sources.lsp",
                        name = "lsp",
                        score_offset = 90,
                        timeout_ms = 2000,
                    },
                    path = {
                        async = true,
                        enabled = true,
                        fallbacks = { "buffer" },
                        min_keyword_length = 0,
                        module = "blink.cmp.sources.path",
                        name = "path",
                        opts = {
                            get_cwd = function(_)
                                return vim.fn.getcwd()
                            end,
                            label_trailing_slash = true,
                            show_hidden_files_by_default = true,
                            trailing_slash = false,
                        },
                        score_offset = 70,
                    },
                    ripgrep = {
                        async = true,
                        enabled = true,
                        module = "blink-ripgrep",
                        name = "grep",
                        opts = {
                            context_size = 5,
                            debug = false,
                            fallback_to_regex_highlighting = true,
                            max_filesize = "1M",
                            prefix_min_len = 3,
                            project_root_fallback = true,
                            project_root_marker = ".git",
                            search_casing = "--ignore-case",
                        },
                        score_offset = 50,
                    },
                    -- snippets = {
                    --     async = false,
                    --     enabled = true,
                    --     max_items = 5,
                    --     min_keyword_length = 2,
                    --     module = "blink.cmp.sources.snippets",
                    --     name = "snip",
                    --     opts = { show_autosnippets = true, use_show_condition = true },
                    --     score_offset = 80,
                    -- },
                    thesaurus = {
                        enabled = function()
                            return vim.tbl_contains({ "gitcommit", "markdown" }, vim.bo.filetype)
                        end,
                        module = "blink-cmp-words.thesaurus",
                        name = "thes",
                        opts = {
                            definition_pointers = { "!", "&", "^" },
                            score_offset = 20,
                            similarity_depth = 2,
                            similarity_pointers = { "&", "^" },
                        },
                    },
                },
            },
            term = { enabled = false },
        })
    end,
}
