local keymap = vim.keymap

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Black hole ops
keymap.set("n", "x", '"_x', { desc = "Del no copy" })
keymap.set("n", "<leader>d", '"_d', { desc = "Del no copy" })
keymap.set("n", "<leader>D", '"_D', { desc = "Del to EOL no copy" })
keymap.set("v", "<leader>d", '"_d', { desc = "Visual del no copy" })
keymap.set("v", "<leader>D", '"_D', { desc = "Visual del to EOL" })
keymap.set("n", "<leader>c", '"_c', { desc = "Change no copy" })
keymap.set("n", "<leader>C", '"_C', { desc = "Change to EOL" })
keymap.set("v", "<leader>c", '"_c', { desc = "Visual change no copy" })
keymap.set("v", "<leader>C", '"_C', { desc = "Visual change to EOL" })

-- Pasting
keymap.set("n", "<leader>p", '"0p', { desc = "Paste 0" })
keymap.set("n", "<leader>P", '"0P', { desc = "Paste before 0" })
keymap.set("v", "<leader>p", '"0p', { desc = "Visual paste 0" })
