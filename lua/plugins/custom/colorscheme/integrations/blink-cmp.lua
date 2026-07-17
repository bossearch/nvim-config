-- stylua: ignore start
return {
    setup = function(p, hi)
        hi('BlinkCmpLabelDeprecated', {fg=p.base03, bg=nil,      attr=nil,    sp=nil})
        hi('BlinkCmpLabelMatch',      {fg=p.base0A, bg=nil,      attr='bold', sp=nil})

        hi('BlinkCmpDoc',             {fg=p.base0T, bg=p.base02, attr=nil,    sp=nil})
        hi('BlinkCmpDocBorder',       {fg=p.base0F, bg=p.base02, attr=nil,    sp=nil})
        hi('BlinkCmpDocSeparator',    {fg=p.base0F, bg=p.base02, attr=nil,    sp=nil})
        hi('BlinkCmpDocCursorLine',   {fg=p.base03, bg=p.base02, attr=nil,    sp=nil})

        hi('BlinkCmpMenuSelection',     {link='CursorLine'})

        hi('BlinkCmpKindClass',         {link='Type'})
        hi('BlinkCmpKindColor',         {link='Special'})
        hi('BlinkCmpKindConstant',      {link='Constant'})
        hi('BlinkCmpKindConstructor',   {link='Type'})
        hi('BlinkCmpKindEnum',          {link='Structure'})
        hi('BlinkCmpKindEnumMember',    {link='Structure'})
        hi('BlinkCmpKindEvent',         {link='Exception'})
        hi('BlinkCmpKindField',         {link='Structure'})
        hi('BlinkCmpKindFile',          {link='Tag'})
        hi('BlinkCmpKindFolder',        {link='Directory'})
        hi('BlinkCmpKindFunction',      {link='Function'})
        hi('BlinkCmpKindInterface',     {link='Structure'})
        hi('BlinkCmpKindKeyword',       {link='Keyword'})
        hi('BlinkCmpKindMethod',        {link='Function'})
        hi('BlinkCmpKindModule',        {link='Structure'})
        hi('BlinkCmpKindOperator',      {link='Operator'})
        hi('BlinkCmpKindProperty',      {link='Structure'})
        hi('BlinkCmpKindReference',     {link='Tag'})
        hi('BlinkCmpKindSnippet',       {link='Special'})
        hi('BlinkCmpKindStruct',        {link='Structure'})
        hi('BlinkCmpKindText',          {link='Statement'})
        hi('BlinkCmpKindTypeParameter', {link='Type'})
        hi('BlinkCmpKindUnit',          {link='Special'})
        hi('BlinkCmpKindValue',         {link='Identifier'})
        hi('BlinkCmpKindVariable',      {link='Delimiter'})
    end,
}
-- stylua: ignore end
