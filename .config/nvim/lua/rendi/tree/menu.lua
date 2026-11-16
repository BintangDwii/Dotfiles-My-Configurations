local M = {}

local palette = require("rendi.core.palette")
local ns = vim.api.nvim_create_namespace("TreeActions")

local menu_win
local menu_buf
local tree_win
local closing = false

local function setup_highlights()
  vim.api.nvim_set_hl(0, "TreeMenuIcon", { fg = palette.purple_alt })
  vim.api.nvim_set_hl(0, "TreeMenuHint", { fg = palette.fg_gutter })
  vim.api.nvim_set_hl(0, "TreeMenuSection", { fg = palette.border })
  vim.api.nvim_set_hl(0, "TreeMenuNormal", { bg = palette.bg_dark, fg = palette.fg })
  vim.api.nvim_set_hl(0, "TreeMenuBorder", { fg = palette.border })
  vim.api.nvim_set_hl(0, "TreeMenuTitle", { fg = palette.purple_alt, bold = true })
  vim.api.nvim_set_hl(0, "TreeMenuCursor", { bg = palette.bg_highlight, fg = palette.fg })
end

local function close_menu()
  if closing or not menu_win then
    return
  end

  closing = true

  local win = menu_win
  menu_win = nil
  menu_buf = nil

  if vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end

  local target = tree_win
  tree_win = nil

  if target and vim.api.nvim_win_is_valid(target) then
    pcall(vim.api.nvim_set_current_win, target)
  end

  closing = false
end

local function build_rows(actions, width)
  local rows = {}
  local row_action = {}
  local lines = {}
  local last_section

  for _, action in ipairs(actions) do
    if action.section ~= last_section then
      if last_section then
        table.insert(rows, { separator = true })
        table.insert(lines, "  " .. string.rep("─", math.max(4, width - 4)))
        row_action[#rows] = nil
      end
      last_section = action.section
    end

    table.insert(rows, action)
    row_action[#rows] = action

    local prefix = "  " .. action.icon .. "  " .. action.label
    local hint = action.hint or ""
    local padding = math.max(1, width - vim.api.nvim_strwidth(prefix) - vim.api.nvim_strwidth(hint) - 2)
    table.insert(lines, prefix .. string.rep(" ", padding) .. hint .. " ")
  end

  return rows, row_action, lines
end

local function add_highlights(buf, rows, lines)
  for index, row in ipairs(rows) do
    local line_index = index - 1

    if row.separator then
      vim.api.nvim_buf_add_highlight(buf, ns, "TreeMenuSection", line_index, 0, -1)
    else
      local line = lines[index]
      local icon_start = line:find(row.icon, 1, true)
      if icon_start then
        vim.api.nvim_buf_add_highlight(buf, ns, "TreeMenuIcon", line_index, icon_start - 1, icon_start - 1 + #row.icon)
      end

      if row.hint and row.hint ~= "" then
        local hint_start = #line - #row.hint - 1
        vim.api.nvim_buf_add_highlight(buf, ns, "TreeMenuHint", line_index, hint_start, hint_start + #row.hint)
      end
    end
  end
end

local function move_cursor(delta, rows, row_action)
  if not menu_win or not vim.api.nvim_win_is_valid(menu_win) then
    return
  end

  local row = vim.api.nvim_win_get_cursor(menu_win)[1]
  local next_row = row

  for _ = 1, #rows do
    next_row = next_row + delta
    if next_row < 1 then
      next_row = #rows
    elseif next_row > #rows then
      next_row = 1
    end

    if row_action[next_row] then
      break
    end
  end

  vim.api.nvim_win_set_cursor(menu_win, { next_row, 0 })
end

function M.open(actions, title)
  local current_win = vim.api.nvim_get_current_win()
  close_menu()
  setup_highlights()

  tree_win = current_win
  if not vim.api.nvim_win_is_valid(tree_win) then
    tree_win = nil
    return
  end

  local width = 34
  for _, action in ipairs(actions) do
    local prefix = "  " .. action.icon .. "  " .. action.label
    local needed = vim.api.nvim_strwidth(prefix) + vim.api.nvim_strwidth(action.hint or "") + 4
    width = math.max(width, needed)
  end
  width = math.min(width, 64)

  local rows, row_action, lines = build_rows(actions, width)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].buflisted = false
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "tree_actions"
  add_highlights(buf, rows, lines)

  local below = vim.o.lines - vim.o.cmdheight - vim.fn.winline()
  local anchor = "NW"
  local row = 1
  local height = math.min(#lines, 20)
  if below < height + 2 then
    anchor = "SW"
    row = -1
  end

  menu_win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    width = width,
    height = height,
    row = row,
    col = 0,
    anchor = anchor,
    border = "rounded",
    style = "minimal",
    zindex = 150,
    title = title,
    title_pos = "center",
  })
  menu_buf = buf

  vim.wo[menu_win].cursorline = true
  vim.wo[menu_win].cursorlineopt = "line"
  vim.wo[menu_win].number = false
  vim.wo[menu_win].relativenumber = false
  vim.wo[menu_win].signcolumn = "no"
  vim.wo[menu_win].wrap = false
  vim.wo[menu_win].winhighlight =
    "CursorLine:TreeMenuCursor,NormalFloat:TreeMenuNormal,FloatBorder:TreeMenuBorder,FloatTitle:TreeMenuTitle"
  vim.api.nvim_win_set_cursor(menu_win, { 1, 0 })

  local function choose()
    local cursor = vim.api.nvim_win_get_cursor(menu_win)
    local action = row_action[cursor[1]]
    close_menu()

    if action then
      action.run()
    end
  end

  local function map(lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf, "n", lhs, "", {
      callback = rhs,
      noremap = true,
      silent = true,
      nowait = true,
    })
  end

  map("<CR>", choose)
  map("<2-LeftMouse>", choose)
  map("<Esc>", close_menu)
  map("<C-c>", close_menu)
  map("q", close_menu)
  map("j", function() move_cursor(1, rows, row_action) end)
  map("k", function() move_cursor(-1, rows, row_action) end)
  map("<Down>", function() move_cursor(1, rows, row_action) end)
  map("<Up>", function() move_cursor(-1, rows, row_action) end)

  local reserved = { j = true, k = true, q = true }
  for _, action in ipairs(actions) do
    local hint = action.hint
    if hint and #hint == 1 and not reserved[hint] then
      map(hint, function()
        close_menu()
        action.run()
      end)
      reserved[hint] = true
    end
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = close_menu,
  })
end

return M
