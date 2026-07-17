-- stylua: ignore start
return {
    setup = function(p, hi)
        hi('NeogitCommitViewHeader',    {link='Special'})
        hi('NeogitDiffAddHighlight',    {link='DiffAdd'})
        hi('NeogitDiffAdd',             {link='DiffAdd'})
        hi('NeogitDiffDeleteHighlight', {link='DiffDelete'})
        hi('NeogitDiffDelete',          {link='DiffDelete'})
        hi('NeogitFold',                {link='FoldColumn'})
        hi('NeogitHunkHeader',          {fg=p.base0D, bg=nil, attr=nil,    sp=nil})
        hi('NeogitHunkHeaderHighlight', {fg=p.base0D, bg=nil, attr='bold', sp=nil})
        hi('NeogitNotificationError',   {link='DiagnosticError'})
        hi('NeogitNotificationInfo',    {link='DiagnosticInfo'})
        hi('NeogitNotificationWarning', {link='DiagnosticWarn'})
    end,
}
-- stylua: ignore end
