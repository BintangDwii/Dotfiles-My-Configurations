vim.lsp.inlay_hint.enable(true)

-- Treesitter must outrank semantic tokens, otherwise rust-analyzer
-- wipes out rstml/leptos highlighting once the workspace loads.
vim.highlight.priorities.treesitter = 150

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP diagnostics" })
