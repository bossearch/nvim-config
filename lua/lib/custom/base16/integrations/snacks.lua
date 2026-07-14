-- stylua: ignore start
local M = {}

M.winhighlight_str = ""

M.setup = function(p, hi)
    hi('SnacksTitle',                   {fg = p.base09, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPicker',                  {fg = p.base05, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerBorder',            {fg = p.base0F, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerBoxBorder',         {fg = p.base09, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerCol',               {fg = p.base03, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerCol',               {fg = p.base03, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerCursorLine',        {link = 'CursorLine'})
    hi('SnacksPickerFile',              {link = 'SnacksPicker'})
    hi('SnacksPickerFooter',            {fg = p.base05, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerIconFile',          {link = 'SnacksPicker'})
    hi('SnacksPickerListCursorLine',    {link = 'CursorLine'})
    hi('SnacksPickerMatch',             {fg = p.base0A, bg = nil,      attr = 'nocombine', sp = nil})
    hi('SnacksPickerPreviewCursorLine', {link = 'CursorLine'})
    hi('SnacksPickerPrompt',            {fg = p.base0E, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerTitle',             {fg = p.base05, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerTree',              {fg = p.base03, bg = p.base00, attr = nil,         sp = nil})
    hi('SnacksPickerInputSearch',       {link = 'SnacksPickerPrompt'})

    local winhighlight_list = {}

        local overrides = {
        Normal             = 'CustomNormal',
        FloatBorder        = 'CustomFloatBorder',
    }

    for global_group, picker_group in pairs(overrides) do
        local hl = vim.api.nvim_get_hl(0, { name = global_group, link = false })
        local current_fg = hl.fg and string.format("#%06x", hl.fg) or nil

        hi(picker_group, { fg = current_fg, bg = p.base00, attr = nil, sp = nil })
        table.insert(winhighlight_list, string.format("%s:%s", global_group, picker_group))
    end

    local persist = {
        CursorLineFold     = 'CustomCursorLineFold',
        CursorLineNr       = 'CustomCursorLineNr',
        CursorLineSign     = 'CustomCursorLineSign',
        FoldColumn         = 'CustomFoldColumn',
        SignColumn         = 'CustomSignColumn',
        MiniDiffSignAdd    = 'CustomMiniDiffSignAdd',
        MiniDiffSignChange = 'CustomMiniDiffSignChange',
        MiniDiffSignDelete = 'CustomMiniDiffSignDelete',
    }

    for global_group, picker_group in pairs(persist) do
        hi(picker_group, { link = global_group })
        table.insert(winhighlight_list, string.format("%s:%s", global_group, picker_group))
    end

    M.winhighlight_str = table.concat(winhighlight_list, ",")
end

return M
-- stylua: ignore end
