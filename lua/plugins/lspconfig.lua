return {
    "nvim-lspconfig",
    spec = { src = "https://github.com/neovim/nvim-lspconfig" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        local group = vim.api.nvim_create_augroup("lsp", {})
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                vim.keymap.set("n", "grn", vim.lsp.buf.rename)
                vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action)
                vim.keymap.set("n", "grD", vim.lsp.buf.declaration)

                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                    return
                end
                -- document highlight
                if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = group,
                        buffer = args.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        group = group,
                        buffer = args.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })
    end,
}
