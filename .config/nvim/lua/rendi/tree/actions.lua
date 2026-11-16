local M = {}

local tree = require("rendi.tree")
local live_server = require("rendi.tree.live_server")
local menu = require("rendi.tree.menu")

local function actions_for(node, api)
  local is_file = node.type == "file"

  local actions = {
    { section = "Open", icon = "", label = "Open", hint = "↵", run = function() api.node.open.edit(node) end },
    {
      section = "Open",
      icon = live_server.is_running(node) and "■" or "▶",
      label = live_server.label(node),
      hint = "s",
      run = function() live_server.toggle(node) end,
    },
    { section = "Edit", icon = "", label = "Cut", hint = "x", run = function() api.fs.cut(node) end },
    { section = "Edit", icon = "", label = "Copy", hint = "c", run = function() api.fs.copy.node(node) end },
    { section = "Edit", icon = "▤", label = "Paste", hint = "p", run = function() api.fs.paste(node) end },
    { section = "Edit", icon = "", label = "Rename", hint = "r", run = function() api.fs.rename(node) end },
    { section = "Edit", icon = "", label = "Delete", hint = "d", run = function() api.fs.remove(node) end },
    { section = "Edit", icon = "", label = "New File/Folder", hint = "n", run = function() api.fs.create(node) end },
    { section = "Path", icon = "", label = "Copy Absolute Path", hint = "A", run = function() api.fs.copy.absolute_path(node) end },
    { section = "Path", icon = "", label = "Copy Relative Path", hint = "R", run = function() api.fs.copy.relative_path(node) end },
    { section = "Path", icon = "", label = "Copy Name", hint = "N", run = function() api.fs.copy.filename(node) end },
  }

  if is_file then
    table.insert(actions, 2, {
      section = "Open",
      icon = "▌",
      label = "Open in Vertical Split",
      hint = "v",
      run = function() api.node.open.vertical(node) end,
    })
    table.insert(actions, 3, {
      section = "Open",
      icon = "▁",
      label = "Open in Horizontal Split",
      hint = "h",
      run = function() api.node.open.horizontal(node) end,
    })
    table.insert(actions, 4, {
      section = "Open",
      icon = "▣",
      label = "Open in New Tab",
      hint = "t",
      run = function() api.node.open.tab(node) end,
    })
    table.insert(actions, 5, {
      section = "Open",
      icon = "",
      label = "Open in Browser",
      hint = "b",
      run = function() live_server.open_direct(node) end,
    })
  end

  return actions
end

function M.open_menu()
  local api = tree.api()
  if not api then
    return
  end

  local win = api.tree.winid() or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  if vim.api.nvim_get_current_win() ~= win then
    pcall(vim.api.nvim_set_current_win, win)
  end

  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  local actions = actions_for(node, api)
  local title = "   Actions · " .. node.name .. " "
  menu.open(actions, title)
end

return M
