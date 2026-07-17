-- stylua: ignore start
return {
    setup = function(p, hi)
        hi('TodoTitle', { fg = p.base00, bg = p.base0C, attr='bold' })
        hi('TodoEntry', { fg = p.base0C, bg = nil,      attr=nil    })

        hi('FixTitle',  { fg = p.base00, bg = p.base08, attr='bold' })
        hi('FixEntry',  { fg = p.base08, bg = nil,      attr=nil    })

        hi('HackTitle', { fg = p.base00, bg = p.base09, attr='bold' })
        hi('HackEntry', { fg = p.base09, bg = nil,      attr=nil    })

        hi('WarnTitle', { fg = p.base00, bg = p.base0A, attr='bold' })
        hi('WarnEntry', { fg = p.base0A, bg = nil,      attr=nil    })

        hi('NoteTitle', { fg = p.base00, bg = p.base0B, attr='bold' })
        hi('NoteEntry', { fg = p.base0B, bg = nil,      attr=nil    })

        hi('TestTitle', { fg = p.base00, bg = p.base0B, attr='bold' })
        hi('TestEntry', { fg = p.base0B, bg = nil,      attr=nil    })

        hi('PerfTitle', { fg = p.base00, bg = p.base0D, attr='bold' })
        hi('PerfEntry', { fg = p.base0D, bg = nil,      attr=nil    })

        hi('BugTitle',  { fg = p.base00, bg = p.base0E, attr='bold' })
        hi('BugEntry',  { fg = p.base0E, bg = nil,      attr=nil    })
    end,
}
-- stylua: ignore end
