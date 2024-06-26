return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration -- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		-- "ibhagwan/fzf-lua",              -- optional
	},
	config = function()
		local neogit = require("neogit")
		neogit.setup({
			mappings = { status = { ["<space>"] = "Stage" } },
		})
	end,
	keys = {
		{ "<leader>git", ":Neogit<cr>", desc = "Neogit" },
	},
}
