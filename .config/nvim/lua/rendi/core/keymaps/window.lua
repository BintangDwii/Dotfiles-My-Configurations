local keymap = vim.keymap

-- Wrap
keymap.set("n", "[w", ":set wrap<CR>", { desc = "Wrap" })
keymap.set("n", "]w", ":set nowrap<CR>", { desc = "No wrap" })

-- Window ops (w* prefix to avoid clashing with substitute operator)
keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Switch window" })
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split horizontal" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equal split" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
keymap.set("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other splits" })
