vim.keymap.set("n", "<C-w>q", function()
    local window = require("lib.util").get_window()

    if #window > 1 then
        vim.cmd("wincmd q")
        return
    end

    local listed_bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buflisted
            and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
    end, vim.api.nvim_list_bufs())

    if #listed_bufs > 1 then
        if vim.bo.modified then
            vim.notify("Cannot close modified buffer", vim.log.levels.WARN)
        else
            vim.cmd("bprevious | bdelete #")
        end
    else
        if vim.fn.tabpagenr("$") > 1 then
            vim.notify("Another tab is opened, can't quit neovim", vim.log.levels.WARN)
        else
            vim.notify("Cannot close last buffer use `q` instead", vim.log.levels.WARN)
        end
    end
end, { noremap = true, desc = "Smart Window/Buffer Close and Quit" })
