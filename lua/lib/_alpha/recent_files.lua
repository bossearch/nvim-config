local function icon(fn)
    local ico, hl = require("mini.icons").get("file", fn)
    return ico or "", hl
end

local function file_button(dashboard, fn, sc, short_fn)
    short_fn = short_fn or fn
    local ico_txt
    local fb_hl = {}

    local ico, hl = icon(fn)
    if ico and ico ~= "" then
        if hl then
            table.insert(fb_hl, { hl, 0, #ico })
        end
        ico_txt = ico .. "  "
    else
        ico_txt = ""
    end

    local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
    file_button_el.opts.width = 60
    file_button_el.opts.hl_shortcut = "Number"

    local ico_len = #ico_txt
    local fn_start = short_fn:match(".*[/\\]")

    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", ico_len, #fn_start + ico_len })
    else
        table.insert(fb_hl, { "Number", ico_len, ico_len + #short_fn })
    end

    file_button_el.opts.hl = fb_hl
    return file_button_el
end

local function get_recent_files(items_number)
    local path_ok1, plenary_path = pcall(require, "plenary.path")
    if not path_ok1 then
        return {}
    end
    pcall(vim.cmd.rshada)
    local dashboard = require("alpha.themes.dashboard")
    items_number = vim.F.if_nil(items_number, 10)

    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        if
            vim.fn.filereadable(v) == 1
            and not v:match("COMMIT_EDITMSG$")
            and not v:match("/nix/store/")
            and not v:match("/tmp/")
        then
            oldfiles[#oldfiles + 1] = v
        end
    end

    if #oldfiles == 0 then
        return { type = "group", val = {}, opts = { shrink_margin = false } }
    end

    local shortcuts = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

    local section_recent_files = {
        type = "group",
        val = function()
            local elements = {}
            local pad_val = vim.o.lines <= 53 and 0 or 1

            table.insert(elements, {
                type = "text",
                val = " Recent files",
                opts = {
                    hl = "SpecialComment",
                    shrink_margin = false,
                    position = "center",
                },
            })

            if pad_val > 0 then
                table.insert(elements, { type = "padding", val = pad_val })
            end

            for i, fn in ipairs(oldfiles) do
                local short_fn = vim.fn.fnamemodify(fn, ":~")
                local shortcut = shortcuts[i] or tostring(i)
                local target_width = 60 - 4 - 2 - #shortcut

                if #short_fn > target_width then
                    short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
                    if #short_fn > target_width then
                        short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
                    end
                end

                local file_button_el = file_button(dashboard, fn, shortcut, short_fn)
                table.insert(elements, file_button_el)

                if i < #oldfiles and pad_val > 0 then
                    table.insert(elements, { type = "padding", val = pad_val })
                end
            end

            return elements
        end,
        opts = { shrink_margin = false },
    }

    return section_recent_files
end

return get_recent_files
