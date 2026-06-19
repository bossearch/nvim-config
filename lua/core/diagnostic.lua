vim.diagnostic.config({
	enable = true,
	severity_sort = true,
	signs = {
		severity = { min = vim.diagnostic.severity.WARN },
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "I",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
	},
	virtual_text = {
		prefix = function(diagnostic)
			local icons = { Error = " E ", Warn = " W ", Hint = " H ", Info = " I " }
			for d, icon in pairs(icons) do
				if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
					return icon
				end
			end
			return "●"
		end,
		spacing = 1,
	},
})
