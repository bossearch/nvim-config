vim.diagnostic.config({
	enable = true,
	signs = true,
	float = {
		source = false,
		header = "",
		scope = "line",
		prefix = "",
		suffix = "",
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
	severity_sort = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

local ns = vim.api.nvim_create_namespace("diag_highest_only")
local orig = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
	show = function(_, bufnr, _, opts)
		local diagnostics = vim.diagnostic.get(bufnr)
		local worst_per_line = {}
		for _, d in ipairs(diagnostics) do
			local existing = worst_per_line[d.lnum]
			if not existing or d.severity < existing.severity then
				worst_per_line[d.lnum] = d
			end
		end
		orig.show(ns, bufnr, vim.tbl_values(worst_per_line), opts)
	end,
	hide = function(_, bufnr)
		orig.hide(ns, bufnr)
	end,
}
