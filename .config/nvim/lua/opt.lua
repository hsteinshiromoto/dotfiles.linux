-- Setup relative and absolute numbers
-- References:
--	[1] https://www.reddit.com/r/neovim/comments/14xxw1p/display_both_relative_and_absolute_line_numbers/

vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.statuscolumn = "%s %l %r "