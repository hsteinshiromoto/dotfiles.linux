local M = {}

function M.on_attach(client, buffer)
	local self = M.new(client, buffer)

	self:map("<localleader>gd", "Telescope lsp_definitions", { desc = "Goto Definition" })
	self:map("<localleader>gr", "Telescope lsp_references", { desc = "References" })
	self:map("<localleader>gD", "Telescope lsp_declarations", { desc = "Goto Declaration" })
	self:map("<localleader>gI", "Telescope lsp_implementations", { desc = "Goto Implementation" })
	self:map("<localleader>gb", "Telescope lsp_type_definitions", { desc = "Goto Type Definition" })
	self:map("K", vim.lsp.buf.hover, { desc = "Hover" })
	self:map("<localleader>gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
	self:map("[d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
	self:map("]d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
	self:map(
		"<localleader>ca",
		vim.lsp.buf.code_action,
		{ desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
	)

	local format = require("plugins.lsp.format").format
	self:map("<localleader>cf", format, { desc = "Format Document", has = "documentFormatting" })
	self:map("<localleader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
	self:map("<localleader>cn", M.rename, { expr = true, desc = "Rename", has = "rename" })

	self:map("<localleader>cs", require("telescope.builtin").lsp_document_symbols, { desc = "Document Symbols" })
	self:map(
		"<localleader>cS",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		{ desc = "Workspace Symbols" }
	)
end

function M.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
	opts = opts or {}
	if opts.has and not self:has(opts.has) then
		return
	end
	vim.keymap.set(
		opts.mode or "n",
		lhs,
		type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
		---@diagnostic disable-next-line: no-unknown
		{ silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
	)
end

function M.rename()
	if pcall(require, "inc_rename") then
		return ":IncRename " .. vim.fn.expand("<cword>")
	else
		vim.lsp.buf.rename()
	end
end

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M

-- References:
-- 	[1] https://alpha2phi.medium.com/modern-neovim-lsp-and-remote-development-9b1250ee6aee
