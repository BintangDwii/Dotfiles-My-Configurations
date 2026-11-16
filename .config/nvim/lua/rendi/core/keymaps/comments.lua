local keymap = vim.keymap

-- Comment cleanup (q* prefix to avoid delaying <leader>d operator)
keymap.set("n", "<leader>qh", [[:%s/<!--.*-->//gc<CR>]], { desc = "Remove HTML comments" })
keymap.set("n", "<leader>qc", [[:%s/\/\*.*\*\///gc<CR>]], { desc = "Remove CSS comments" })
keymap.set("n", "<leader>q-", [[:%s/--.*//gc<CR>]], { desc = "Remove -- comments" })
keymap.set("n", "<leader>q;", [[:%s/;.*//gc<CR>]], { desc = "Remove ; comments" })
keymap.set("n", "<leader>q/", [[:%s/\/\/.*//gc<CR>]], { desc = "Remove // comments" })
keymap.set("n", "<leader>q#", [[:%s/#.*//gc<CR>]], { desc = "Remove # comments" })
keymap.set("n", "<leader>qb", [[:%s/\n\{3,}/\r\r/gc<CR>]], { desc = "Collapse blank lines" })
keymap.set("n", "<leader>qs", [[:/\v(#|--|\/\/|;|<!--.*-->|\/\*.*\*\/).*<CR>]], { desc = "Search comments" })
