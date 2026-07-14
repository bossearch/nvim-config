return {
    "nvim-lspconfig",
    spec = { src = "https://github.com/neovim/nvim-lspconfig" },
    event = { "BufReadPre", "BufNewFile" },
    after = function()
        local group = vim.api.nvim_create_augroup("lsp", {})
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                    return
                end

                local Mappings = {
                    ["Hover"] = "K",
                    ["Signature Help"] = "<C-S>",
                    ["Code Action"] = "gra",
                    ["Run Codelens"] = "grx",
                    ["Rename"] = "grn",
                }

                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
                    map(Mappings["Hover"], vim.lsp.buf.hover, "Hover")
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
                    map(Mappings["Signature Help"], vim.lsp.buf.signature_help, "Signature Help", { "i", "s" })
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
                    map(Mappings["Code Action"], vim.lsp.buf.code_action, "Code Action", { "n", "x" })
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
                    map(Mappings["Run Codelens"], vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
                end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
                    map(Mappings["Rename"], vim.lsp.buf.rename, "Rename")
                end

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
