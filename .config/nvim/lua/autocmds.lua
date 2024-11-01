---
--- References:
--- 	[1] https://www.dmsussman.org/resources/neovimsetup/
---

local autogroup = vim.api.nvim_create_augroup
local localGroup = autogroup("DMS", {})
local autocmd = vim.api.nvim_create_autocmd
-- resize splits if the window itself is resized
autocmd("VimResized", {
	group = localGroup,
	callback = function()
		local currentTab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. currentTab)
	end,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
