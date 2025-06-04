--- Diagnostic configuration for Neovim.
--
-- This module defines a `setup` function that applies global diagnostic
-- settings compatible with Neovim >= 0.11. The function is executed
-- immediately upon require, but it is returned as well so that callers can
-- re-run it if they need to.
--
-- The settings enable virtual *lines* (full-width diagnostic messages) and
-- disable virtual *text* (inline messages) to avoid duplication. The rest of
-- the options mirror the behaviour requested by the user while remaining
-- LSP-agnostic, so they do not interfere with Mason, nvim-lspconfig, or any
-- other client tooling.
--
-- All options come from `:h vim.diagnostic.config`.
local M = {}

--- Apply global diagnostic settings.
--
-- This function is safe to run multiple times and is automatically skipped on
-- Neovim versions older than 0.11 (the first version that shipped
-- `virtual_lines`).
--
-- Returns:
--     nil
function M.setup()
  -- Only apply the configuration on Neovim ≥ 0.11.
  if vim.fn.has("nvim-0.11") == 0 then
    return
  end

  vim.diagnostic.config({
    -- Disable inline text and enable full-line virtual diagnostics.
    virtual_text = false,
    virtual_lines = true,

    -- UI/UX tweaks.
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    -- Floating-window appearance for `hover` or `show` commands.
    float = {
      border = "rounded",
      source = "always", -- Always show the diagnostic source (e.g. eslint).
    },
  })
end

-- Execute immediately so that the configuration is active as soon as the
-- module is required.
M.setup()

return M 