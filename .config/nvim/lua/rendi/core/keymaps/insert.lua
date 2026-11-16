local keymap = vim.keymap

-- Insert mode
keymap.set("i", "<C-c>", "<Esc>", { desc = "Esc insert" })
keymap.set("i", "<C-h>", "<Left>", { desc = "←" })
keymap.set("i", "<C-l>", "<Right>", { desc = "→" })
keymap.set("i", "<C-d>", "<Delete>", { desc = "Del char" })
keymap.set("i", "<C-w>", "<C-o>db<C-o>x", { desc = "Del word ←" })
keymap.set("i", "<C-D>", "<C-o>dw", { desc = "Del word →" })
