-- Add at the top of your init.lua
local args = vim.v.argv
local is_remote = false
for _, arg in ipairs(args) do
	if arg == "--remote-ui" or arg:match("^--server") then
		is_remote = true
		break
	end
end

-- Later in your config, when loading plugins:
if not is_remote then
	require("config.options")
	require("config.lazy")
	require("config.icons")

	-- Global diagnostic configuration (Neovim ≥ 0.11)
	require("config.diagnostics")

	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			require("config.autocmds")
			require("config.keymaps")
		end,
	})
-- Load your regular plugins here
else
	-- Load only minimal plugins needed for remote work
end
