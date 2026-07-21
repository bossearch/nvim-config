local function toggle_bool(fallback_key)
    -- markdown checkbox
    if vim.bo.filetype == "markdown" then
        local current_line = vim.api.nvim_get_current_line()
        if current_line:match("%s*%- %[% %]") then
            local new_line = current_line:gsub("(%- %[)( )(%])", "%1x%3", 1)
            vim.api.nvim_set_current_line(new_line)
            return
        elseif current_line:match("%s*%- %[[xX]%]") then
            local new_line = current_line:gsub("(%- %[[xX])(%])", "- [ ]", 1)
            vim.api.nvim_set_current_line(new_line)
            return
        end
    end

    -- booleans
    local word = vim.fn.expand("<cword>")
    local bool_map = {
        ["true"] = "false",
        ["false"] = "true",
        ["True"] = "False",
        ["False"] = "True",
        ["and"] = "or",
        ["or"] = "and",
        ["yes"] = "no",
        ["no"] = "yes",
        ["on"] = "off",
        ["off"] = "on",
        ["left"] = "right",
        ["right"] = "left",
        ["top"] = "bottom",
        ["bottom"] = "top",
    }

    if bool_map[word] then
        vim.cmd("normal! ciw" .. bool_map[word])
        return
    end

    local keys = vim.api.nvim_replace_termcodes(fallback_key, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
end

vim.keymap.set("n", "<C-a>", function()
    toggle_bool("<C-a>")
end, { desc = "Toggle boolean/checkbox or increment" })
vim.keymap.set("n", "<C-x>", function()
    toggle_bool("<C-x>")
end, { desc = "Toggle boolean/checkbox or decrement" })
