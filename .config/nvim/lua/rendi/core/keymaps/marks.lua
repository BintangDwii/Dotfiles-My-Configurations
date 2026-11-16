local keymap = vim.keymap

-- Set marks / jump marks (generated)
for _, m in ipairs({ "a", "A", "b", "B", "c", "C" }) do
  keymap.set("n", "<leader>m" .. m, "m" .. m, { desc = "Set mark " .. m })
  keymap.set("n", "<leader>j" .. m, "'" .. m, { desc = "Jump " .. m })
end
keymap.set("n", "<leader>km", ":delmarks ", { desc = "Del mark" })
keymap.set("n", "<leader>lm", ":marks<CR>", { desc = "List marks" })
