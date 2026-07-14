-- stylua: ignore start
return {
    setup = function(p, hi)
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
        hi('SnacksPickerTitle',             {fg = p.base05, bg = p.base01, attr = nil,         sp = nil})
        hi('SnacksPickerTree',              {fg = p.base03, bg = p.base01, attr = nil,         sp = nil})
        hi('SnacksPickerInputSearch',       {link = 'SnacksPickerPrompt'})
        local SnacksBackdrop =  p.base00
        _G.SnacksBackdrop = SnacksBackdrop
    end,
}
-- stylua: ignore end
