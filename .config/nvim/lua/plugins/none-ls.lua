return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.completion.spell,
			},
		})
		vim.keymap.set("n", "F", vim.lsp.buf.format, { desc = "Format File"})
	end,
}
