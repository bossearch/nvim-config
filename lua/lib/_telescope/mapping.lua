local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")

local function get_user_keymaps()
    local modes = { "n", "i", "v", "x", "t" }
    local user_maps = {}
    local seen = {}

    for i = 1, #modes do
        local mode = modes[i]
        local maps = vim.api.nvim_get_keymap(mode)
        local buf_maps = vim.api.nvim_buf_get_keymap(0, mode)

        for j = 1, #buf_maps do
            maps[#maps + 1] = buf_maps[j]
        end

        for j = 1, #maps do
            local map = maps[j]
            local raw_lhs = map.lhs or ""

            -- Filter out empty keys, standalone spaces, and Neovim default help menus
            if raw_lhs ~= "" and raw_lhs ~= " " and not (map.desc and map.desc:match("%-default")) then
                local is_core_default = false
                local info = nil

                if map.callback then
                    info = debug.getinfo(map.callback)
                    if info and info.source and (info.source:match("defaults%.lua") or info.source:match("_core")) then
                        is_core_default = true
                    end
                end

                if not is_core_default then
                    local lhs = vim.fn.keytrans(raw_lhs):gsub(" ", "<Space>"):gsub("<lt>", "<")
                    local unique_id = mode .. lhs

                    -- Filter out duplicate keys, standalone spaces, and plugin keys
                    if not seen[unique_id] and lhs ~= "<Space>" and not lhs:lower():match("plug") then
                        local action
                        if map.desc and map.desc ~= "" then
                            action = map.desc
                        elseif map.rhs and map.rhs ~= "" then
                            action = map.rhs
                        elseif info and info.source and info.linedefined then
                            action = string.format("Lua: %s:%d", info.source:gsub("^@", ""), info.linedefined)
                        else
                            action = map.callback and "Lua function" or ""
                        end

                        -- Filter out mappings that execute internal plugin code
                        if action and not action:lower():match("plug") then
                            seen[unique_id] = true
                            user_maps[#user_maps + 1] = {
                                mode = mode,
                                lhs = lhs,
                                action = action,
                            }
                        end
                    end
                end
            end
        end
    end
    return user_maps
end

return function(opts)
    opts = opts or {}

    local keymap_opts = vim.tbl_deep_extend("force", {
        prompt_title = "Keymap Cheat Sheet",
        finder = finders.new_table({
            results = get_user_keymaps(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format("[%s]  %-18s ❯ %s", entry.mode, entry.lhs, entry.action),
                    ordinal = entry.mode .. " " .. entry.lhs .. " " .. entry.action,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
    }, opts)

    pickers
        .new(keymap_opts, {
            attach_mappings = function(_, map)
                map("i", "<CR>", actions.nop)
                map("n", "<CR>", actions.nop)
                return true
            end,
        })
        :find()
end
