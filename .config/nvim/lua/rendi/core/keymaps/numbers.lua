local keymap = vim.keymap

-- Number
keymap.set("n", "+", "<C-a>", { desc = "Increment" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement" })
