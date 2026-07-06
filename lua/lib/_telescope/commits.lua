local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local commit_types = {
    { type = "feat", desc = "A new feature for the user" },
    { type = "fix", desc = "A bug fix for the user" },
    { type = "docs", desc = "Documentation changes" },
    { type = "style", desc = "Changes that do not affect the meaning of the code" },
    { type = "refactor", desc = "A code change that neither fixes a bug nor adds a feature" },
    { type = "perf", desc = "A code change that improves performance" },
    { type = "test", desc = "Adding missing tests or correcting existing tests" },
    { type = "chore", desc = "Changes to the build process or auxiliary tools/libraries" },
    { type = "ci", desc = "Changes to CI/CD pipelines" },
    { type = "revert", desc = "Reverts a specific commit" },
}

local function commit_picker(opts)
    opts = opts or {}

    pickers
        .new(opts, {
            prompt_title = "Conventional Commits",
            finder = finders.new_table({
                results = commit_types,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = string.format("%-12s ❯ %s", entry.type, entry.desc),
                        ordinal = entry.type .. " " .. entry.desc,
                    }
                end,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local function custom_insert_action()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    if selection and selection.value.type then
                        local commit_type = selection.value.type

                        vim.schedule(function()
                            vim.ui.input({ prompt = "Commit scope (optional): " }, function(scope)
                                local commit_prefix

                                if scope and scope:gsub("%s+", "") ~= "" then
                                    commit_prefix = string.format("%s(%s): ", commit_type, scope:gsub("%s+", ""))
                                else
                                    commit_prefix = commit_type .. ": "
                                end

                                vim.api.nvim_put({ commit_prefix }, "c", true, true)
                                vim.cmd("startinsert!")
                            end)
                        end)
                    end
                end

                map("i", "<CR>", custom_insert_action)
                map("n", "<CR>", custom_insert_action)
                return true
            end,
        })
        :find()
end

return commit_picker
