local keymap = vim.keymap

-- LSP lifecycle
keymap.set("n", "<leader>lx", ":LspStop<CR>", { desc = "Stop LSP" })
keymap.set("n", "<leader>ls", ":LspStart<CR>", { desc = "Start LSP" })

-- Go to line:column
keymap.set("n", "<leader>lc", function()
  require("rendi.quickfix.extract").extract_to_qflist()
end, { desc = "Extract Rust errors to quickfix" })
