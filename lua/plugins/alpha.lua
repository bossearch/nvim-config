return {
    "alpha-nvim",
    spec = { src = "https://github.com/goolord/alpha-nvim" },
    cmd = "Alpha",
    after = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        local height = vim.o.lines
        local head_button_pad = 2
        local button_button_pad = 1
        local button_footer_pad = 1
        local footer_footer_pad = 1
        local builtin_button_pad = 1
        if height <= 53 then
            head_button_pad = 1
            button_button_pad = 1
            builtin_button_pad = 0
            footer_footer_pad = 0
        end

        local gh_contrib = require("lib._alpha").gh_contrib()

        local recent_files = require("lib._alpha").recent_files()

        local projects = require("lib._alpha").recent_project()

        dashboard.section.buttons.opts.spacing = builtin_button_pad
        dashboard.section.buttons.val = {
            dashboard.button("s", "  Restore session", ":lua require('mini.sessions').read('global-session')<cr>"),
            dashboard.button("q", "  Quit", ":qa!<cr>"),
        }
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.width = 60
            button.opts.hl_shortcut = "Number"
            button.opts.hl = "SpecialComment"
        end

        local function footer_1()
            local tip = require("lib._alpha").get_tips()
            local max_line_width = 60
            local lines = {}
            for raw_line in vim.gsplit(tip, "\n", { trimempty = true }) do
                local current_line = ""
                for word in string.gmatch(raw_line, "%S+") do
                    if current_line == "" then
                        current_line = word
                    elseif #current_line + #word + 1 <= max_line_width then
                        current_line = current_line .. " " .. word
                    else
                        table.insert(lines, current_line)
                        current_line = word
                    end
                end
                if current_line ~= "" then
                    table.insert(lines, current_line)
                end
            end
            local group_elements = {}
            for _, line in ipairs(lines) do
                table.insert(group_elements, {
                    type = "text",
                    val = line,
                    opts = {
                        position = "center",
                        hl = "Title",
                    },
                })
            end
            return {
                type = "group",
                val = group_elements,
                opts = { shrink_margin = false },
            }
        end
        local function footer_2()
            local p = vim.pack.get()
            local time = require("lib._alpha").get_startup_time._startup_time
            return {
                type = "text",
                val = { " Neovim loaded " .. #p .. " plugins in " .. time },
                opts = {
                    position = "center",
                    hl = {
                        { "Special", 0, 1 },
                        { "Title", 2, 31 },
                        { "Number", 31, 50 },
                    },
                },
            }
        end
        local function footer_3()
            local v = vim.version()
            local version = " " .. v.major .. "." .. v.minor .. "." .. v.patch
            return {
                type = "text",
                val = version,
                opts = {
                    position = "center",
                    hl = "Comment",
                },
            }
        end
        dashboard.section.footer_1 = footer_1()
        dashboard.section.footer_2 = footer_2()
        dashboard.section.footer_3 = footer_3()

        -- layout
        local alpha_height = #gh_contrib.val
            + head_button_pad
            + #recent_files.val()
            + button_button_pad
            + #projects.val()
            + button_button_pad
            + #dashboard.section.buttons.val
            + button_footer_pad
            + #dashboard.section.footer_1.val
            + footer_footer_pad
            + #dashboard.section.footer_2.val
            + footer_footer_pad
            + #dashboard.section.footer_3.val
            - 7 -- yeah some janky stuff for centering my dashboard
        local top_pad = math.max(0, math.ceil((vim.o.lines - alpha_height) / 2))

        dashboard.config.layout = {
            { type = "padding", val = top_pad },
            gh_contrib,
            { type = "padding", val = head_button_pad },
            recent_files,
            { type = "padding", val = button_button_pad },
            projects,
            { type = "padding", val = button_button_pad },
            dashboard.section.buttons,
            { type = "padding", val = button_footer_pad },
            dashboard.section.footer_1,
            { type = "padding", val = footer_footer_pad },
            dashboard.section.footer_2,
            { type = "padding", val = footer_footer_pad },
            dashboard.section.footer_3,
        }

        alpha.setup(dashboard.opts)

        -- clean alpha buffer
        vim.api.nvim_create_autocmd("User", {
            once = true,
            pattern = "AlphaReady",
            callback = function()
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.statuscolumn = ""
                vim.opt_local.fillchars = { eob = " " }
                vim.opt_local.laststatus = 0
                local hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
                hl.blend = 100
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.api.nvim_set_hl(0, "Cursor", hl)
                vim.opt.guicursor:append("a:Cursor/lCursor")
            end,
        })

        vim.api.nvim_create_autocmd("BufWinLeave", {
            pattern = "*",
            callback = function(args)
                if vim.bo[args.buf].filetype == "alpha" then
                    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
                    hl.blend = 0
                    ---@diagnostic disable-next-line: param-type-mismatch
                    vim.api.nvim_set_hl(0, "Cursor", hl)
                    vim.opt.guicursor:remove("a:Cursor/lCursor")
                    vim.cmd("bd 1")
                end
            end,
        })
    end,
}
