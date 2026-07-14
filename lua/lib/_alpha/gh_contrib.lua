local colors = {
    ["#ebedf0"] = "GitHub0",
    ["#9be9a8"] = "GitHub1",
    ["#40c463"] = "GitHub2",
    ["#30a14e"] = "GitHub3",
    ["#216e39"] = "GitHub4",
}
vim.api.nvim_set_hl(0, "GitHub0", { fg = "#414868" })
vim.api.nvim_set_hl(0, "GitHub1", { fg = "#216e39" })
vim.api.nvim_set_hl(0, "GitHub2", { fg = "#30a14e" })
vim.api.nvim_set_hl(0, "GitHub3", { fg = "#40c463" })
vim.api.nvim_set_hl(0, "GitHub4", { fg = "#9be9a8" })

local icons = {
    block_empty = "",
    circle_empty = "",
    block_full = "",
    circle_full = "",
}

local function read_colors(path)
    local days = {}
    for line in io.lines(path) do
        line = vim.trim(line)
        if line ~= "" then
            days[#days + 1] = line
        end
    end
    return days
end

local function get_gh_contrib(path)
    path = path or (os.getenv("HOME") .. "/.cache/bosse/gh-contrib")

    local days = read_colors(path)
    local total_days = #days
    if total_days == 0 then
        return { type = "group", val = {}, opts = { shrink_margin = false } }
    end

    local n_weeks = math.ceil(total_days / 7)
    local now = os.time()
    local today = os.date("*t", now)
    local sunday_offset = today.wday - 1

    local base_time = now - (sunday_offset + (n_weeks - 1) * 7) * 86400

    -- Only show the last 6 months to keep the dashboard clean
    local allowed = {}
    for i = 0, 5 do
        local t = { year = today.year, month = today.month - i, day = 1 }
        allowed[os.date("%b", os.time(t))] = true
    end

    local month_line = string.rep(" ", n_weeks * 2)
    local last_month
    local day_numbers = {}

    for w = 0, n_weeks - 1 do
        local week_start = base_time + w * 7 * 86400
        local week_month = nil

        -- Figure out what day number every block is, and watch for the 1st of the month
        for d = 0, 6 do
            local timestamp = week_start + d * 86400
            if (w * 7 + d + 1) <= total_days then
                local idx = w * 7 + d + 1
                local t = os.date("*t", timestamp)
                day_numbers[idx] = t.day
                if t.day == 1 then
                    week_month = os.date("%b", timestamp)
                end
            end
        end

        -- Handle the edge case where data starts mid-month
        if w == 0 and not week_month then
            week_month = os.date("%b", week_start)
        end

        -- Drop the month label right above the column where the transition happens
        if week_month and week_month ~= last_month and allowed[week_month] then
            local col = w * 2 + 1
            month_line = month_line:sub(1, col - 1) .. week_month .. month_line:sub(col + 3)
            last_month = week_month
        end
    end

    local lines = { "    " .. month_line }

    local alpha_hl = {}
    for i = 1, 8 do
        alpha_hl[i] = {}
    end

    -- Cache string lengths so we aren't re-running '#' inside the loops
    local len_b_empty = #icons.block_empty
    local len_b_full = #icons.block_full
    local len_c_empty = #icons.circle_empty
    local len_c_full = #icons.circle_full

    local prefixes = {
        [0] = "    ",
        [1] = "Mon ",
        [2] = "    ",
        [3] = "Wed ",
        [4] = "    ",
        [5] = "Fri ",
        [6] = "    ",
    }

    -- Build the matrix and map out text highlights at the same time
    for d = 0, 6 do
        local prefix = prefixes[d]
        local row_chunks = { prefix }
        local chunk_idx = 2
        local current_byte_len = #prefix
        local line_index = #lines + 1

        for w = 0, n_weeks - 1 do
            local idx = w * 7 + d + 1
            if idx <= total_days then
                local color = days[idx]
                local day = day_numbers[idx]
                local is_empty = (color == "#ebedf0")

                local char, char_len
                if day == 1 then
                    if is_empty then
                        char, char_len = icons.circle_empty, len_c_empty
                    else
                        char, char_len = icons.circle_full, len_c_full
                    end
                else
                    if is_empty then
                        char, char_len = icons.block_empty, len_b_empty
                    else
                        char, char_len = icons.block_full, len_b_full
                    end
                end

                row_chunks[chunk_idx] = char
                row_chunks[chunk_idx + 1] = " "
                chunk_idx = chunk_idx + 2

                -- Track highlight positions for Alpha
                table.insert(alpha_hl[line_index], {
                    colors[color] or "Normal",
                    current_byte_len,
                    current_byte_len + char_len,
                })
                current_byte_len = current_byte_len + char_len + 1
            else
                row_chunks[chunk_idx] = "  "
                chunk_idx = chunk_idx + 1
                current_byte_len = current_byte_len + 2
            end
        end
        lines[line_index] = table.concat(row_chunks)
    end

    local section_contrib = {
        type = "group",
        val = {},
        opts = { shrink_margin = false },
    }

    for i, text_line in ipairs(lines) do
        table.insert(section_contrib.val, {
            type = "text",
            val = text_line,
            opts = {
                hl = alpha_hl[i] or {},
                position = "center",
            },
        })
    end

    section_contrib.lines = #section_contrib.val
    return section_contrib
end

return get_gh_contrib
