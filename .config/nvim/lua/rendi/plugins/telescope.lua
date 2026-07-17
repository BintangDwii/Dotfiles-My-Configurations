local function builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts or {})
  end
end

local regex_magic = {
  ["\\"] = true,
  ["."] = true,
  ["^"] = true,
  ["$"] = true,
  ["|"] = true,
  ["?"] = true,
  ["*"] = true,
  ["+"] = true,
  ["("] = true,
  [")"] = true,
  ["["] = true,
  ["]"] = true,
  ["{"] = true,
  ["}"] = true,
}

-- Convert "src auth" into an fd-compatible fuzzy regex such as
-- "s.*r.*c.*a.*u.*t.*h". Filtering happens in fd before Telescope sees data.
local function fd_fuzzy_pattern(prompt)
  local parts = {}

  for _, char in ipairs(vim.fn.split(prompt or "", [[\zs]])) do
    if not char:match("%s") then
      if regex_magic[char] then
        char = "\\" .. char
      end
      parts[#parts + 1] = char
    end
  end

  if #parts == 0 then
    return nil
  end

  return table.concat(parts, ".*")
end

-- Query-driven file picker:
--   * starts empty, so opening it does not enumerate the repository
--   * cancels/restarts fd whenever the prompt changes
--   * externally prefilters and caps results before they enter Telescope
local function progressive_files(opts)
  opts = vim.tbl_deep_extend("force", {
    cwd = vim.uv.cwd(),
    max_results = 800,
    prompt_title = "Files (progressive)",
    disable_devicons = true,
  }, opts or {})

  local fd = vim.fn.exepath("fd")
  if fd == "" then
    vim.notify("progressive_files requires fd; using Telescope find_files", vim.log.levels.WARN)
    require("telescope.builtin").find_files({
      cwd = opts.cwd,
      hidden = true,
      follow = false,
      disable_devicons = true,
    })
    return
  end

  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title,
      finder = finders.new_job(function(prompt)
        local pattern = fd_fuzzy_pattern(prompt)
        if not pattern then
          return nil
        end

        return {
          fd,
          "--type",
          "f",
          "--hidden",
          "--full-path",
          "--color",
          "never",
          "--exclude",
          ".git",
          "--exclude",
          "node_modules",
          "--exclude",
          "target",
          "--exclude",
          "dist",
          "--exclude",
          "build",
          "--exclude",
          ".cache",
          "--max-results",
          tostring(opts.max_results),
          pattern,
          ".",
        }
      end, opts.entry_maker or make_entry.gen_from_file(opts), opts.max_results, opts.cwd),
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

-- Complete repository search for the rare case where the bounded progressive
-- picker does not find what you need. git ls-files is fastest inside Git repos.
local function complete_files()
  local cwd = vim.uv.cwd()
  local git_root = vim.fs.root(cwd, ".git")
  local telescope_builtin = require("telescope.builtin")

  if git_root then
    telescope_builtin.git_files({
      cwd = git_root,
      show_untracked = true,
      recurse_submodules = false,
      disable_devicons = true,
    })
    return
  end

  telescope_builtin.find_files({
    cwd = cwd,
    hidden = true,
    follow = false,
    disable_devicons = true,
  })
end

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
            display = string.format("%s %d  %s", tab.current and "*" or " ", tab.index, tab.filename),
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

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", progressive_files, desc = "Find files progressively" },
      { "<leader>fF", complete_files, desc = "Find all repository files" },
      { "<leader>fb", builtin("buffers"), desc = "Buffers" },
      { "<leader>fr", builtin("oldfiles"), desc = "Recent files" },
      { "<leader>fs", builtin("live_grep"), desc = "Grep string" },
      { "<leader>fc", builtin("grep_string"), desc = "Grep word under cursor" },
      { "<leader>fh", builtin("help_tags"), desc = "Help tags" },
      { "<leader>fm", builtin("man_pages"), desc = "Man pages" },
      { "<leader>fk", builtin("keymaps"), desc = "Keymaps" },
      { "<leader>fco", builtin("commands"), desc = "Commands" },
      { "<leader>ft", tabs_picker, desc = "Tabs" },
      { "<leader>fd", builtin("diagnostics"), desc = "Diagnostics" },
      { "<leader>fds", builtin("lsp_document_symbols"), desc = "Document symbols" },
      {
        "<leader>fws",
        builtin("lsp_dynamic_workspace_symbols"),
        desc = "Workspace symbols (dynamic)",
      },
      { "<leader>fdr", builtin("lsp_references"), desc = "References" },
      { "<leader>fdi", builtin("lsp_implementations"), desc = "Implementations" },
      { "<leader>fdd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "<leader>fdt", builtin("lsp_type_definitions"), desc = "Type definitions" },
      { "<leader>fgc", builtin("git_commits", { max_results = 1000 }), desc = "Git commits" },
      { "<leader>fgb", builtin("git_bcommits", { max_results = 1000 }), desc = "Git buffer commits" },
      { "<leader>fgs", builtin("git_status"), desc = "Git status" },
      { "<leader>fgB", builtin("git_branches"), desc = "Git branches" },
      { "<leader>fgst", builtin("git_stash"), desc = "Git stash" },
      { "<leader>fR", builtin("resume"), desc = "Resume picker" },
      { "<leader>fj", builtin("jumplist"), desc = "Jumplist" },
      { "<leader>f/", builtin("search_history"), desc = "Search history" },
      { "<leader>f?", builtin("command_history"), desc = "Command history" },
      { "<leader>fq", builtin("quickfix"), desc = "Quickfix list" },
      { "<leader>fl", builtin("loclist"), desc = "Location list" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local action_state = require("telescope.actions.state")

      local function open_with_trouble(prompt_bufnr)
        require("trouble.sources.telescope").open(prompt_bufnr)
      end

      local function send_to_qf_and_open_trouble(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)

        if #picker:get_multi_selection() > 0 then
          actions.send_selected_to_qflist(prompt_bufnr)
        else
          actions.send_to_qflist(prompt_bufnr)
        end

        vim.schedule(function()
          require("trouble").open("qflist")
        end)
      end

      local fd_find_command
      if vim.fn.executable("fd") == 1 then
        fd_find_command = {
          "fd",
          "--type",
          "f",
          "--hidden",
          "--color",
          "never",
          "--exclude",
          ".git",
          "--exclude",
          "node_modules",
          "--exclude",
          "target",
          "--exclude",
          "dist",
          "--exclude",
          "build",
          "--exclude",
          ".cache",
        }
      end

      telescope.setup({
        defaults = {
          prompt_prefix = "> ",
          selection_caret = "> ",

          -- "smart" compares paths against each other and gets expensive.
          path_display = { "truncate" },
          color_devicons = false,

          sorting_strategy = "ascending",
          layout_strategy = "flex",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.50,
            },
            vertical = {
              mirror = true,
              prompt_position = "top",
            },
            width = 0.90,
            height = 0.82,
            preview_cutoff = 120,
          },

          -- Keep resume useful without retaining huge result sets in memory.
          cache_picker = {
            num_pickers = 2,
            limit_entries = 500,
            ignore_empty_prompt = true,
          },

          -- Preview is constructed only when requested with <C-a> / p.
          preview = {
            hide_on_startup = true,
            filesize_limit = 1,
            highlight_limit = 1,
            timeout = 100,
            treesitter = false,
          },

          -- Let ripgrep/gitignore do filtering before Lua sees each result.
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!**/.git/**",
            "--glob",
            "!**/node_modules/**",
            "--glob",
            "!**/target/**",
            "--glob",
            "!**/dist/**",
            "--glob",
            "!**/build/**",
            "--glob",
            "!**/.cache/**",
            "--max-columns",
            "240",
          },

          set_env = { COLORTERM = "truecolor" },

          mappings = {
            i = {
              ["<C-q>"] = send_to_qf_and_open_trouble,
              ["<C-s>"] = open_with_trouble,
              ["<C-a>"] = action_layout.toggle_preview,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<Esc>"] = actions.close,
              ["?"] = actions.which_key,
            },
            n = {
              ["p"] = action_layout.toggle_preview,
              ["<C-q>"] = send_to_qf_and_open_trouble,
              ["<C-s>"] = open_with_trouble,
              ["?"] = actions.which_key,
            },
          },
        },

        pickers = {
          buffers = {
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            disable_devicons = true,
            mappings = {
              i = {
                ["<C-x>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          find_files = {
            hidden = true,
            follow = false,
            disable_devicons = true,
            find_command = fd_find_command,
          },
          git_files = {
            show_untracked = true,
            disable_devicons = true,
          },
          live_grep = {
            disable_devicons = true,
          },
          grep_string = {
            disable_devicons = true,
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ast_grep = {
            command = { "sg", "--json=stream" },
          },
          ["ui-select"] = require("telescope.themes").get_dropdown({
            previewer = false,
          }),
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fB",
        function()
          local telescope = require("telescope")
          telescope.load_extension("file_browser")
          telescope.extensions.file_browser.file_browser({
            hidden = true,
            respect_gitignore = true,
            git_status = false,
            previewer = false,
          })
        end,
        desc = "File browser",
      },
    },
  },

  {
    "Marskey/telescope-sg",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fa",
        function()
          require("telescope").load_extension("ast_grep")
          vim.cmd("Telescope ast_grep")
        end,
        desc = "AST Grep",
      },
    },
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
    },
    keys = {
      {
        "<leader>fy",
        function()
          local telescope = require("telescope")
          telescope.load_extension("neoclip")
          telescope.extensions.neoclip.plus({ extra = [[",star]] })
        end,
        desc = "Clipboard history",
      },
    },
    config = function()
      require("neoclip").setup({
        history = 500,
        enable_persistent_history = true,
        length_limit = 262144,
        continuous_sync = false,
        preview = false,
        default_register = { '"', "+", "*" },
        enable_system_clipboard = true,
        keys = {
          telescope = {
            i = {
              select = "<CR>",
              paste = "<C-j>",
              paste_behind = "<C-k>",
              replay = "<C-q>",
              delete = "<C-d>",
            },
            n = {
              select = "<CR>",
              paste = "p",
              paste_behind = "P",
              replay = "q",
              delete = "d",
            },
          },
        },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
    keys = {
      { "<leader>ftd", "<cmd>TodoTelescope<CR>", desc = "Todo comments" },
    },
  },
}
