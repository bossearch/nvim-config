-- stylua: ignore start
return {
    setup = function(p, hi)
        -- Tree-sitter
        -- Sources:
        -- - `:h treesitter-highlight-groups`
        -- - https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights
        -- Included only those differing from default links
        hi('@keyword.return', {fg=p.base08, bg=nil, attr=nil, sp=nil})
        hi('@symbol',         {fg=p.base0E, bg=nil, attr=nil, sp=nil})
        hi('@variable',       {fg=p.base05, bg=nil, attr=nil, sp=nil})

        hi('@text.strong',    {fg=nil, bg=nil, attr='bold',          sp=nil})
        hi('@text.emphasis',  {fg=nil, bg=nil, attr='italic',        sp=nil})
        hi('@text.strike',    {fg=nil, bg=nil, attr='strikethrough', sp=nil})
        hi('@text.underline', {link='Underlined'})

        -- Semantic tokens. Source: `:h lsp-semantic-highlight`.
        -- Included only those differing from default links
        hi('@lsp.type.variable',  {fg=p.base05, bg=nil, attr=nil, sp=nil})
        hi('@lsp.mod.deprecated', {fg=p.base08, bg=nil, attr=nil, sp=nil})

        -- New tree-sitter groups
        hi('@markup.strong',        {link='@text.strong'})
        hi('@markup.italic',        {link='@text.emphasis'})
        hi('@markup.strikethrough', {link='@text.strike'})
        hi('@markup.underline',     {link='@text.underline'})

        hi('@markup.heading.1', {link='markdownH1'})
        hi('@markup.heading.2', {link='markdownH2'})
        hi('@markup.heading.3', {link='markdownH3'})
        hi('@markup.heading.4', {link='markdownH4'})
        hi('@markup.heading.5', {link='markdownH5'})
        hi('@markup.heading.6', {link='markdownH6'})

        hi('@string.special.vimdoc',     {link='SpecialChar'})
        hi('@variable.parameter.vimdoc', {fg=p.base09, bg=nil, attr=nil, sp=nil})
        hi('@markup.heading.4.vimdoc',   {link='Title'})
    end,
}
