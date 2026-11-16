local M = {}

-- Tiny native tabs picker; avoids loading the now-archived telescope-tabs plugin.
local function tabs_picker()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  local current = vim.api.nvim_get_current_tabpage()
  local tabs = {}

  for index, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    local window = vim.api.nvim_tabpage_get_win(tabpage)
    local buffer = vim.api.nvim_win_get_buf(window)
    local filename = vim.api.nvim_buf_get_name(buffer)

    tabs[#tabs + 1] = {
      index = index,
      tabpage = tabpage,
      filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":~:."),
      current = tabpage == current,
    }
  end

  pickers
    .new({}, {
      prompt_title = "Tabs",
      finder = finders.new_table({
        results = tabs,
        entry_maker = function(tab)
          return {
            value = tab,
            ordinal = string.format("%d %s", tab.index, tab.filename),
            display = string.format("%s  %d  %s", tab.current and "󰄬" or " ", tab.index, tab.filename),
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = false,
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          if selection and vim.api.nvim_tabpage_is_valid(selection.value.tabpage) then
            vim.api.nvim_set_current_tabpage(selection.value.tabpage)
          end
        end)

        return true
      end,
    })
    :find()
end

M.tabs_picker = tabs_picker

return M
