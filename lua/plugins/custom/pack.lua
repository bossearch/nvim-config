local pack_table = _G.pack_table

_G.pack_table = nil

if vim.fn.exists(":PackInstall") == 0 then
    local function with_pack(callback)
        vim.pack.add(pack_table, { confirm = false })
        callback()
    end

    -- install
    vim.api.nvim_create_user_command("PackInstall", function()
        with_pack(function() end)
    end, {})

    -- cleanup
    vim.api.nvim_create_user_command("PackCleanup", function()
        with_pack(function()
            local non_active = {}
            for _, pack in ipairs(vim.pack.get()) do
                if not pack.active then
                    table.insert(non_active, pack.spec.name)
                end
            end

            if #non_active == 0 then
                vim.notify("No non-active plugins found")
                return
            end

            local message = "Non-active plugins:\n\n"
                .. table.concat(non_active, "\n")
                .. "\n\nDelete "
                .. #non_active
                .. " plugin(s)?\n"

            if vim.fn.confirm(message, "&Yes\n&No") == 1 then
                vim.pack.del(non_active)
                vim.notify("Deleted " .. #non_active .. " plugin(s)")
            end
        end)
    end, {})

    -- update
    vim.api.nvim_create_user_command("PackUpdate", function()
        with_pack(function()
            vim.pack.update()
        end)
    end, {})
end
