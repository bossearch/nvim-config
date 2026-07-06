local function icon()
    local ico, hl = require("mini.icons").get("directory", "")
    return ico or " ", hl or "Directory"
end

local function project_button(dashboard, dir, sc, short_dir)
    short_dir = short_dir or dir
    local ico, hl = icon()
    local ico_txt = ico .. "  "
    local fb_hl = {}

    if hl then
        table.insert(fb_hl, { hl, 0, #ico })
    end

    local dir_start = short_dir:match(".*[/\\]")
    if dir_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt, #dir_start + #ico_txt })
    end

    local cmd = string.format("<cmd>cd %s | Telescope find_files<CR>", vim.fn.fnameescape(dir))

    local button_el = dashboard.button(sc, ico_txt .. short_dir, cmd)
    button_el.opts.width = 60
    button_el.opts.hl_shortcut = "Number"
    button_el.opts.hl = fb_hl
    return button_el
end

local function get_projects(max_items)
    local path_ok1, plenary_path = pcall(require, "plenary.path")
    if not path_ok1 then
        return { type = "group", val = {}, opts = { shrink_margin = false } }
    end
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

    -- Return an empty group block if no valid git projects exist to prevent printing an empty header
    if #projects == 0 then
        return { type = "group", val = {}, opts = { shrink_margin = false } }
    end

    local pad_val = vim.o.lines <= 56 and 0 or 1
    local buttons_tbl = {}
    local shortcuts = { "a", "b", "c", "d", "e" }

    for i, dir in ipairs(projects) do
        local short_dir = vim.fn.fnamemodify(dir, ":~")
        local shortcut = shortcuts[i] or tostring(i)
        local target_width = 60 - 4 - 2 - #shortcut

        if #short_dir > target_width then
            short_dir = plenary_path.new(short_dir):shorten(1, { -2, -1 })
            if #short_dir > target_width then
                short_dir = plenary_path.new(short_dir):shorten(1, { -1 })
            end
        end

        table.insert(buttons_tbl, project_button(dashboard, dir, shortcut, short_dir))

        -- Keep 1-line padding between buttons
        if i < #projects then
            table.insert(buttons_tbl, { type = "padding", val = pad_val })
        end
    end

    local section_projects = {
        type = "group",
        val = {
            {
                type = "text",
                val = "  Projects",
                opts = { hl = "SpecialComment", shrink_margin = false, position = "center" },
            },
            { type = "padding", val = pad_val },
        },
        opts = { shrink_margin = false },
    }

    for _, item in ipairs(buttons_tbl) do
        table.insert(section_projects.val, item)
    end

    section_projects.lines = #section_projects.val
    return section_projects
end

return get_projects
