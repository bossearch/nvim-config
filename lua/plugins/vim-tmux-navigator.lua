return {
    "vim-tmux-navigator",
    spec = { src = "https://github.com/christoomey/vim-tmux-navigator" },
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
    },
    keys = {
        { "<c-h>", ":TmuxNavigateLeft<cr>",  mode = { "n", "v", "i", "x" }, noremap = true, silent = true },
        { "<c-j>", ":TmuxNavigateDown<cr>",  mode = { "n", "v", "i", "x" }, noremap = true, silent = true },
        { "<c-k>", ":TmuxNavigateUp<cr>",    mode = { "n", "v", "i", "x" }, noremap = true, silent = true },
        { "<c-l>", ":TmuxNavigateRight<cr>", mode = { "n", "v", "i", "x" }, noremap = true, silent = true },
    },
}
