return {
	"kevinhwang91/nvim-ufo",
	lazy = false,
	dependencies = {
		"kevinhwang91/promise-async",
		"neovim/nvim-lspconfig",
		{
			"luukvbaal/statuscol.nvim",
			lazy = false,
			config = function()
				vim.opt.number = true
				vim.opt.relativenumber = true
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					relculright = true,
					segments = {
						{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
						{ text = { "%s", " " }, click = "v:lua.ScSa" }, -- git signs
						{ text = { "%=", "%l " }, click = "v:lua.ScLa" }, -- Absolute line numbers
						{ text = { "%r " }, click = "v:lua.ScLa" }, -- Relative line numbers
					},
				})
			end,
		},
	},
}
