-- stylua: ignore start
return {
    setup = function(p, hi)
        -- Tree-sitter. Source: `:h treesitter-highlight-groups`.
        hi('@keyword.return', {fg=p.base08, bg=nil, attr=nil, sp=nil})
        hi('@variable',       {fg=p.base05, bg=nil, attr=nil, sp=nil})

        hi('@markup.strong',        {fg=nil, bg=nil, attr='bold',          sp=nil})
        hi('@markup.italic',        {fg=nil, bg=nil, attr='italic',        sp=nil})
        hi('@markup.strikethrough', {fg=nil, bg=nil, attr='strikethrough', sp=nil})
        hi('@markup.underline',     {link='Underlined'})

        hi('@markup.heading.1', {link='markdownH1'})
        hi('@markup.heading.2', {link='markdownH2'})
        hi('@markup.heading.3', {link='markdownH3'})
        hi('@markup.heading.4', {link='markdownH4'})
        hi('@markup.heading.5', {link='markdownH5'})
        hi('@markup.heading.6', {link='markdownH6'})

        hi('@string.special.vimdoc',     {link='SpecialChar'})
        hi('@variable.parameter.vimdoc', {fg=p.base09, bg=nil, attr=nil, sp=nil})
        hi('@markup.heading.4.vimdoc',   {link='Title'})

        -- Semantic tokens. Source: `:h lsp-semantic-highlight`.
        -- Included only those differing from default links
        hi('@lsp.type.variable',  {fg=p.base05, bg=nil, attr=nil, sp=nil})
        hi('@lsp.mod.deprecated', {fg=p.base08, bg=nil, attr=nil, sp=nil})
    end,
}
-- stylua: ignore end
