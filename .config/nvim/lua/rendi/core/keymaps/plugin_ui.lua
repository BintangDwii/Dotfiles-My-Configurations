local keymap = vim.keymap

-- Plugin UIs
keymap.set("n", "<leader>ld", "<Cmd>lua require('lazydocker').toggle()<CR>", { desc = "Toggle LazyDocker" })
keymap.set("n", "<leader>lz", ":Lazy<CR>", { desc = "Lazy.nvim" })

-- Startup profiling
keymap.set("n", "<leader>lp", function()
  vim.cmd("Lazy profile")
end, { desc = "Lazy profile" })
keymap.set("n", "<leader>mm", ":Mason<CR>", { desc = "Mason" })
