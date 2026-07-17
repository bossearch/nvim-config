-- stylua: ignore start
return {
    setup = function(p, hi)
        hi('MiniDiffOverAdd',        {fg=p.base0B, bg=p.base01, attr='blend', sp=nil})
        hi('MiniDiffOverChange',     {fg=p.base0C, bg=p.base01, attr='blend', sp=nil})
        hi('MiniDiffOverChangeBuf',  {link='MiniDiffOverChange'})
        hi('MiniDiffOverContext',    {fg=nil     , bg=p.base01, attr=nil,     sp=nil})
        hi('MiniDiffOverContextBuf', {})
        hi('MiniDiffOverDelete',     {fg=p.base08, bg=p.base01, attr='blend', sp=nil})
        hi('MiniDiffSignAdd',        {link='DiffAdd'})
        hi('MiniDiffSignChange',     {link='DiffChange'})
        hi('MiniDiffSignDelete',     {link='DiffDelete'})

        hi('MiniIconsAzure',  {fg=p.base0D, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsBlue',   {fg=p.base0F, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsCyan',   {fg=p.base0C, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsGreen',  {fg=p.base0B, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsGrey',   {fg=p.base07, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsOrange', {fg=p.base09, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsPurple', {fg=p.base0E, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsRed',    {fg=p.base08, bg=nil, attr=nil, sp=nil})
        hi('MiniIconsYellow', {fg=p.base0A, bg=nil, attr=nil, sp=nil})

        hi('MiniIndentscopeSymbol',    {fg=p.base03, bg=nil, attr=nil, sp=nil})
        hi('MiniIndentscopeSymbolOff', {fg=p.base03, bg=nil, attr=nil, sp=nil})

        hi('MiniSurround', {link='IncSearch'})
    end,
}
-- stylua: ignore end
