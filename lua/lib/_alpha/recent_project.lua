local function icon()
    local ico, hl = require("mini.icons").get("directory", "")
    return ico or " ", hl or "Directory"
end

local function shorten_path(path, exclude_count)
    local parts = {}
    for part in string.gmatch(path, "[^/]+") do
        table.insert(parts, part)
    end
    local num_parts = #parts
    if num_parts == 0 then
        return path
    end

    for i = 1, num_parts - exclude_count do
        if parts[i] ~= "~" and parts[i] ~= "" then
            parts[i] = parts[i]:sub(1, 1)
        end
    end
    local prefix = path:sub(1, 1) == "/" and "/" or ""
    return prefix .. table.concat(parts, "/")
end

local function project_button(dashboard, dir, sc, short_dir)
    short_dir = short_dir or dir
    local ico, hl = icon()
    local ico_txt = ico .. "  "
    local fb_hl = {}

    if hl then
        table.insert(fb_hl, { hl, 0, #ico })
    end

    local ico_len = #ico_txt
    local dir_start = short_dir:match(".*[/\\]")

    if dir_start ~= nil then
        table.insert(fb_hl, { "Comment", ico_len, #dir_start + ico_len })
    else
        table.insert(fb_hl, { "Number", ico_len, ico_len + #short_dir })
    end

    -- telescope
    -- local cmd = string.format("<cmd>lua require('telescope.builtin').find_files({ cwd = '%s' })<CR>", vim.fn.fnameescape(dir))
    -- snacks picker
    local cmd = string.format("<cmd>lua require('snacks').picker.files({ cwd = '%s' })<CR>", vim.fn.fnameescape(dir))

    local button_el = dashboard.button(sc, ico_txt .. short_dir, cmd)
    button_el.opts.width = 60
    button_el.opts.hl_shortcut = "Number"
    button_el.opts.hl = fb_hl
    return button_el
end

local function get_projects(max_items)
    pcall(vim.cmd.rshada)
    local dashboard = require("alpha.themes.dashboard")
    max_items = vim.F.if_nil(max_items, 5)

    local projects = {}
    local seen = {}

    for _, file in ipairs(vim.v.oldfiles) do
        if #projects >= max_items then
            break
        end
        if
            vim.fn.filereadable(file) == 1
            and not file:match("COMMIT_EDITMSG$")
            and not file:match("/nix/store/")
            and not file:match("/tmp/")
        then
            local dir = vim.fn.fnamemodify(file, ":p:h")
            local git_root = nil

            if vim.fs.root then
                git_root = vim.fs.root(dir, ".git")
            else
                local match = vim.fs.find(".git", { path = dir, upward = true })
                if match[1] then
                    git_root = vim.fn.fnamemodify(match[1], ":p:h:h")
                end
            end

            if git_root and not seen[git_root] then
                seen[git_root] = true
                table.insert(projects, git_root)
            end
        end
    end

    if #projects == 0 then
        return {
            type = "group",
            val = function()
                return {}
            end,
            opts = { shrink_margin = false },
        }
    end

    local shortcuts = { "a", "b", "c", "d", "e" }

    local section_projects = {
        type = "group",
        val = function()
            local elements = {}
            local pad_val = vim.o.lines <= 53 and 0 or 1

            table.insert(elements, {
                type = "text",
                val = "  Projects",
                opts = { hl = "SpecialComment", shrink_margin = false, position = "center" },
            })

            if pad_val > 0 then
                table.insert(elements, { type = "padding", val = pad_val })
            end

            for i, dir in ipairs(projects) do
                local short_dir = vim.fn.fnamemodify(dir, ":~")
                local shortcut = shortcuts[i] or tostring(i)
                local target_width = 60 - 4 - 2 - #shortcut

                if #short_dir > target_width then
                    short_dir = shorten_path(short_dir, 2)
                    if #short_dir > target_width then
                        short_dir = shorten_path(short_dir, 1)
                    end
                end

                local project_button_el = project_button(dashboard, dir, shortcut, short_dir)
                table.insert(elements, project_button_el)

                if i < #projects and pad_val > 0 then
                    table.insert(elements, { type = "padding", val = pad_val })
                end
            end

            return elements
        end,
        opts = { shrink_margin = false },
    }

    return section_projects
end

return get_projects
