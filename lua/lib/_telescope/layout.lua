local layout_strategies = require("telescope.pickers.layout_strategies")

layout_strategies.ivy_flush = function(self, max_columns, max_lines, layout_config)
    -- 1. Deduct 1 line from max_lines to make room for your statusline
    local adjusted_max_lines = max_lines - 1

    -- 2. Pass the adjusted max_lines into the base bottom_pane calculator
    local layout = layout_strategies.bottom_pane(self, max_columns, adjusted_max_lines, layout_config)

    layout.results.border = true

    if layout.preview then
        layout.preview.border = true

        -- 3. Shift prompt up by 1 line so it sits cleanly above the list/preview
        layout.prompt.line = layout.prompt.line - 1

        -- 4. Sync the start lines perfectly so they share the exact same top boundary
        layout.results.line = layout.prompt.line + 2
        layout.preview.line = layout.results.line

        -- 5. Expand heights to reclaim the shifted row space
        layout.results.height = layout.results.height + 1
        layout.preview.height = layout.results.height

        -- 6. Render the precise border masks
        layout.results.borderchars = { "─", "", "", "", "─", "─", "", "" }
        layout.preview.borderchars = { "─", "", "", "│", "┬", "─", "", "" }
    else
        -- Fallback layout behavior if the preview window is hidden or disabled
        layout.prompt.line = layout.prompt.line - 1
        layout.results.line = layout.prompt.line + 2
        layout.results.height = layout.results.height + 1
        layout.results.borderchars = { "─", "", "", "", "─", "─", "", "" }
    end

    return layout
end

return true
