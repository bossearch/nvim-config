return {
    "markdown-preview.nvim",
    spec = {
        src = "https://github.com/iamcco/markdown-preview.nvim",
    },
    ft = "markdown",
    keys = {
        { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Preview markdown file" },
    },
    after = function()
        local app = vim.fn.stdpath("data") .. "/site/pack/core/opt/markdown-preview.nvim/app"
        if vim.fn.isdirectory(app .. "/bin") == 0 then
            vim.fn["mkdp#util#install"]()
        end
    end,
}
