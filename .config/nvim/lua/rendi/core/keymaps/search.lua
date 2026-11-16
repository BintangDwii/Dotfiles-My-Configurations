local keymap = vim.keymap

-- Search
keymap.set("n", "<leader>g", "*", { desc = "Search word ↓" })
keymap.set("n", "<leader>G", "#", { desc = "Search word ↑" })
keymap.set("n", "<leader>zg", "g*", { desc = "Search partial ↓" })
keymap.set("n", "<leader>zG", "g#", { desc = "Search partial ↑" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlight" })
