-- =============================================================================
-- Custom Base16 Colorscheme Engine
--
-- Derived from mini.base16 (part of mini.nvim)
-- MIT License Copyright (c) 2021 Evgeni Chasnovski
--
-- Based on the original Base16 specification by Chris Kempson
-- Copyright (C) 2012 Chris Kempson
-- =============================================================================

local Base16 = {}
local H = {}

Base16.config = {
    palette = nil,
}

-- blend
local blend_cache = {}

local function color_to_rgb(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)
    return { r, g, b }
end

---@param fg string
---@param bg string
---@param alpha number
local function blend(fg, bg, alpha)
    local cache_key = fg .. bg .. alpha
    if blend_cache[cache_key] then
        return blend_cache[cache_key]
    end

    local fg_rgb = color_to_rgb(fg)
    local bg_rgb = color_to_rgb(bg)

    local function blend_channel(i)
        local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    local result = string.format("#%02X%02X%02X", blend_channel(1), blend_channel(2), blend_channel(3))
    blend_cache[cache_key] = result
    return result
end

Base16.setup = function(config)
    config = config or {}
    H.validate_base16_palette(config.palette, "config.palette")
    H.apply_palette(config.palette)
end

H.base16_names = {
    "base00",
    "base01",
    "base02",
    "base03",
    "base04",
    "base05",
    "base06",
    "base07",
    "base08",
    "base09",
    "base0A",
    "base0B",
    "base0C",
    "base0D",
    "base0E",
    "base0F",
}

H.validate_base16_palette = function(x, x_name)
    if type(x) ~= "table" then
        error(string.format("(base16) `%s` is not a table.", x_name))
    end
    for _, color_name in ipairs(H.base16_names) do
        local c = x[color_name]
        if c == nil then
            error(string.format("(base16) `%s` does not have value %s.", x_name, color_name))
        end
        H.validate_hex(c, string.format("%s.%s", x_name, color_name))
    end
    return true
end

H.validate_hex = function(x, x_name)
    local is_hex = type(x) == "string" and x:len() == 7 and x:sub(1, 1) == "#" and (tonumber(x:sub(2), 16) ~= nil)
    if not is_hex then
        error(string.format('(base16) `%s` is not a HEX color (string "#RRGGBB").', x_name))
    end
    return true
end

H.highlight = function(group, args, palette)
    if args.link ~= nil then
        vim.cmd(string.format("highlight! link %s %s", group, args.link))
        return
    end

    local fg = args.fg or "NONE"
    local bg = args.bg or "NONE"
    local attr = args.attr or "NONE"

    if attr == "blend" and fg ~= "NONE" then
        bg = blend(fg, palette.base01, 0.1)
        attr = "NONE"
    end

    if attr == "trans" and bg ~= "NONE" then
        bg = blend(bg, palette.base01, 0.4)
        attr = "NONE"
    end

    vim.cmd(string.format("highlight %s guifg=%s guibg=%s gui=%s guisp=%s", group, fg, bg, attr, args.sp or "NONE"))
end

H.apply_palette = function(palette)
    if vim.g.colors_name then
        vim.cmd("highlight clear")
    end
    vim.g.colors_name = nil

    local p = palette
    local hi = function(group, args)
        H.highlight(group, args, p)
    end

    vim.g.terminal_color_0 = p.base00
    vim.g.terminal_color_1 = p.base08
    vim.g.terminal_color_2 = p.base0B
    vim.g.terminal_color_3 = p.base0A
    vim.g.terminal_color_4 = p.base0D
    vim.g.terminal_color_5 = p.base0E
    vim.g.terminal_color_6 = p.base0C
    vim.g.terminal_color_7 = p.base05
    vim.g.terminal_color_8 = p.base03
    vim.g.terminal_color_9 = p.base08
    vim.g.terminal_color_10 = p.base0B
    vim.g.terminal_color_11 = p.base0A
    vim.g.terminal_color_12 = p.base0D
    vim.g.terminal_color_13 = p.base0E
    vim.g.terminal_color_14 = p.base0C
    vim.g.terminal_color_15 = p.base07

    -- load integrations
    local util = require("lib.util")

    util.scan_modules("lua/plugins/custom/colorscheme/builtin", "plugins.custom.colorscheme.builtin.", function(module)
        if type(module.setup) == "function" then
            module.setup(p, hi)
        end
    end)

    util.scan_modules(
        "lua/plugins/custom/colorscheme/integrations",
        "plugins.custom.colorscheme.integrations.",
        function(module)
            if type(module.setup) == "function" then
                module.setup(p, hi)
            end
        end
    )
end

return Base16
