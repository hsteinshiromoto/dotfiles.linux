-- lsp/servers.lua

local M = {}

local lsp_utils = require("plugins.lsp.utils")

function M.setup(_, opts)
	lsp_utils.on_attach(function(client, buffer)
		require("plugins.lsp.format").on_attach(client, buffer)
		require("plugins.lsp.keymaps").on_attach(client, buffer)
	end)

	local servers = opts.servers

	-- Ensure mason is loaded and set up
	local mason_ok, _ = pcall(require, "mason")
	if not mason_ok then
		vim.notify("Mason not found. Please ensure it's installed correctly.", vim.log.levels.ERROR)
		return
	end

	-- Ensure mason-lspconfig is loaded
	local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not mason_lspconfig_ok then
		vim.notify("mason-lspconfig not found. Please ensure it's installed correctly.", vim.log.levels.ERROR)
		return
	end

	-- Setup mason-lspconfig for server installation if available (v2 returns a table)
	if type(mason_lspconfig.setup) == "function" then
		mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
	end

	-- Manual setup of each server without relying on setup_handlers
	local lspconfig = require("lspconfig")
	for server_name, server_opts in pairs(servers) do
		server_opts.capabilities = lsp_utils.capabilities()

		if opts.setup[server_name] then
			if opts.setup[server_name](server_name, server_opts) then
				-- If the custom setup returns true, skip the default setup
				goto continue
			end
		elseif opts.setup["*"] then
			if opts.setup["*"](server_name, server_opts) then
				-- If the wildcard setup returns true, skip the default setup
				goto continue
			end
		end

		-- Default setup
		lspconfig[server_name].setup(server_opts)

		::continue::
	end

	-- Handle automatically installed servers from mason-lspconfig
	local installed_servers = {}
	if mason_lspconfig and type(mason_lspconfig.get_installed_servers) == "function" then
		installed_servers = mason_lspconfig.get_installed_servers()
	end
	for _, server_name in ipairs(installed_servers) do
		-- Skip servers that are already configured
		if servers[server_name] then
			goto next_server
		end

		local server_opts = {}
		server_opts.capabilities = lsp_utils.capabilities()

		if opts.setup[server_name] then
			if opts.setup[server_name](server_name, server_opts) then
				goto next_server
			end
		elseif opts.setup["*"] then
			if opts.setup["*"](server_name, server_opts) then
				goto next_server
			end
		end

		lspconfig[server_name].setup(server_opts)

		::next_server::
	end
end

return M
