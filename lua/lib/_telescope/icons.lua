local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function icon_picker(opts)
    opts = opts or {}

    local json_path = vim.fn.stdpath("config") .. "/lua/lib/_telescope/icons.json"

    local f = io.open(json_path, "r")
    if not f then
        vim.notify("Could not find icons.json at " .. json_path, vim.log.levels.ERROR)
        return
    end

    local content = f:read("*a")
    f:close()

    local ok, icons = pcall(vim.json.decode, content)
    if not ok or type(icons) ~= "table" then
        vim.notify("Failed to parse icons.json. Check syntax!", vim.log.levels.ERROR)
        return
    end

    pickers
        .new(opts, {
            prompt_title = "Icons",
            finder = finders.new_table({
                results = icons,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = string.format("%s   %-30s %s", entry.icon, entry.name, entry.category),
                        ordinal = entry.name .. " " .. entry.category,
                    }
                end,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local function custom_insert_action()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection and selection.value.icon then
                        local icon_symbol = selection.value.icon
                        vim.api.nvim_put({ icon_symbol }, "c", true, true)
                    end
                end

                map("i", "<CR>", custom_insert_action)
                map("n", "<CR>", custom_insert_action)

                return true
            end,
        })
        :find()
end

return icon_picker
