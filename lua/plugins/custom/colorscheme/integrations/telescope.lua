-- stylua: ignore start
return {
    setup = function(p, hi)
        hi('TelescopeNormal',         {fg=p.base05, bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopeBorder',         {fg=p.base0F, bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopeTitle',          {fg=p.base09, bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopePromptBorder',   {fg=p.base09, bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopeMatching',       {fg=p.base0A, bg=nil,      attr=nil,         sp=nil})
        hi('TelescopeMultiSelection', {fg=nil,      bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopeSelection',      {fg=nil,      bg=p.base02, attr='nocombine', sp=nil})
        hi('TelescopeSelectionCaret', {fg=p.base08, bg=p.base00, attr=nil,         sp=nil})
        hi('TelescopePromptPrefix',   {link='Keyword'})
    end,
}
-- stylua: ignore end
