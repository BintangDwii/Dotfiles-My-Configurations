local M = {}

function M.api()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    return nil
  end
  return api
end

function M.open()
  local api = M.api()
  if not api then
    return false
  end

  if api.tree.is_visible() then
    return true
  end

  local focus = vim.api.nvim_get_current_win()
  api.tree.open()

  if vim.api.nvim_win_is_valid(focus) then
    pcall(vim.api.nvim_set_current_win, focus)
  end

  return true
end

function M.reopen()
  local api = M.api()
  if not api then
    return
  end

  if not api.tree.is_visible() then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NvimTree" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end

  M.open()
  pcall(api.tree.change_root, vim.fn.getcwd())
  pcall(api.tree.reload)
end

return M
