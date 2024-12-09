return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- see below for full list of optional dependencies 👇
	},
	-- Add condition to only load plugin if directory .obsidian is present [1, 2]
	cond = vim.fn.isdirectory(".obsidian") == 1,
	ui = { enable = false },
	keys = {

		{ "<localleader>t", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
		{ "<localleader>l", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
	},
	new_notes_location = "notes_subdir",
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Personal",
			},
			{
				name = "LOR",
				path = "~/Work/LOR",
			},
		},
		templates = {
			folder = "_meta_/_templates_",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		-- Optional, customize how note IDs are generated given an optional title.
		---@param title string|?
		---@return string
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.date("%Y-%m-%d")) .. " " .. suffix
		end,
	},
}
-- References:
--   [1] https://stackoverflow.com/questions/67259998/neovim-lua-isdirectory-vim-function
--   [2] https://github.com/LazyVim/LazyVim/discussions/2600#discussioncomment-8572894
