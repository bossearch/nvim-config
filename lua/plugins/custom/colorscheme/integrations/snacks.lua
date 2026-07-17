-- stylua: ignore start
local M = {}

M.custom_hl = ""

M.setup = function(p, hi)
    hi('SnacksTitle',                   {fg = p.base09, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPicker',                  {fg = p.base05, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerBorder',            {fg = p.base0F, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerBoxBorder',         {fg = p.base09, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerCol',               {fg = p.base03, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerCol',               {fg = p.base03, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerCursorLine',        {link = 'CursorLine'})
    hi('SnacksPickerFile',              {link = 'SnacksPicker'})
    hi('SnacksPickerFooter',            {fg = p.base05, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerIconFile',          {link = 'SnacksPicker'})
    hi('SnacksPickerListCursorLine',    {link = 'CursorLine'})
    hi('SnacksPickerMatch',             {fg = p.base0A, bg = nil,      attr = 'nocombine', sp = nil})
    hi('SnacksPickerPreviewCursorLine', {link = 'CursorLine'})
    hi('SnacksPickerPrompt',            {fg = p.base0E, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerTitle',             {fg = p.base0D, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerTree',              {fg = p.base03, bg = p.base01, attr = nil,         sp = nil})
    hi('SnacksPickerInputSearch',       {link = 'SnacksPickerPrompt'})

    M.backdrop = p.base00

    local winhighlight_list = {}

        local overrides = {
        Normal             = 'CustomNormal',
        FloatBorder        = 'CustomFloatBorder',
        Title              = 'CustomTitle',
        SnacksPickerPrompt = 'CustomSnacksPickerPrompt',
    }

    for global_group, picker_group in pairs(overrides) do
        local hl = vim.api.nvim_get_hl(0, { name = global_group, link = false })
        local current_fg = hl.fg and string.format("#%06x", hl.fg) or nil

        hi(picker_group, { fg = current_fg, bg = p.base00, attr = nil, sp = nil })
        table.insert(winhighlight_list, string.format("%s:%s", global_group, picker_group))
    end

    M.custom_hl = table.concat(winhighlight_list, ",")
end


return M
-- stylua: ignore end
