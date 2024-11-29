return {
	"luukvbaal/statuscol.nvim",
	lazy = false,
	config = function()
		vim.o.number = true
		vim.o.relativenumber = true

		local builtin = require("statuscol.builtin")

		require("statuscol").setup({
			segments = {
				relculright = true,

				-- Absolute line number
				{
					text = {
						function(args)
							return string.format("%4d ", args.lnum) -- Added space after absolute number
						end,
					},
					click = "v:lua.ScLa",
				},
				-- Relative line number
				{
					text = { builtin.lnumfunc },
					click = "v:lua.ScLa",
				},

				{
					sign = { namespace = { "gitsigns" }, name = { ".*" }, maxwidth = 1, colwidth = 2, auto = false },
					click = "v:lua.ScSa",
				},
				{
					sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
				-- {
				-- 	text = {
				-- 		'%{%foldclosed(v:lnum)==v:lnum?"%#Italic#%#DiagnosticVirtualTextWarn#":""%}',
				-- 		builtin.lnumfunc,
				-- 	},
				-- },
				{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
			},
		})
	end,
}
