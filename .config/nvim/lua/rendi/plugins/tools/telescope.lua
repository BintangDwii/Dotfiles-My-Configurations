local pickers = require("rendi.telescope.pickers")
local tabs = require("rendi.telescope.tabs")

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", pickers.progressive_files, desc = "Find files progressively" },
      { "<leader>fF", pickers.complete_files, desc = "Find all repository files" },
      { "<leader>fb", pickers.builtin("buffers"), desc = "Buffers" },
      { "<leader>fr", pickers.builtin("oldfiles"), desc = "Recent files" },
      { "<leader>fs", pickers.builtin("live_grep"), desc = "Grep string" },
      { "<leader>fc", pickers.builtin("grep_string"), desc = "Grep word under cursor" },
      { "<leader>fh", pickers.builtin("help_tags"), desc = "Help tags" },
      { "<leader>fm", pickers.builtin("man_pages"), desc = "Man pages" },
      { "<leader>fk", pickers.builtin("keymaps"), desc = "Keymaps" },
      { "<leader>fco", pickers.builtin("commands"), desc = "Commands" },
      { "<leader>ft", tabs.tabs_picker, desc = "Tabs" },
      { "<leader>fd", pickers.builtin("diagnostics"), desc = "Diagnostics" },
      { "<leader>fds", pickers.builtin("lsp_document_symbols"), desc = "Document symbols" },
      {
        "<leader>fws",
        pickers.builtin("lsp_dynamic_workspace_symbols"),
        desc = "Workspace symbols (dynamic)",
      },
      { "<leader>fdr", pickers.builtin("lsp_references"), desc = "References" },
      { "<leader>fdi", pickers.builtin("lsp_implementations"), desc = "Implementations" },
      { "<leader>fdd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "<leader>fdt", pickers.builtin("lsp_type_definitions"), desc = "Type definitions" },
      { "<leader>fgc", pickers.builtin("git_commits", { max_results = 1000 }), desc = "Git commits" },
      { "<leader>fgb", pickers.builtin("git_bcommits", { max_results = 1000 }), desc = "Git buffer commits" },
      { "<leader>fgs", pickers.builtin("git_status"), desc = "Git status" },
      { "<leader>fgB", pickers.builtin("git_branches"), desc = "Git branches" },
      { "<leader>fgst", pickers.builtin("git_stash"), desc = "Git stash" },
      { "<leader>fR", pickers.builtin("resume"), desc = "Resume picker" },
      { "<leader>fj", pickers.builtin("jumplist"), desc = "Jumplist" },
      { "<leader>f/", pickers.builtin("search_history"), desc = "Search history" },
      { "<leader>f?", pickers.builtin("command_history"), desc = "Command history" },
      { "<leader>fq", pickers.builtin("quickfix"), desc = "Quickfix list" },
      { "<leader>fl", pickers.builtin("loclist"), desc = "Location list" },
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
        fd_find_command = vim.list_extend({ "fd" }, pickers.fd_args)
      end

      telescope.setup({
        defaults = {
          -- Keep resume useful without retaining huge result sets in memory.
          cache_picker = {
            num_pickers = 2,
            limit_entries = 500,
            ignore_empty_prompt = true,
          },

          -- Keep the normal visible preview, with strict limits for large files.
          preview = {
            hide_on_startup = false,
            filesize_limit = 1,
            highlight_limit = 1,
            timeout = 100,
            treesitter = true,
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
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-v>"] = actions.select_vertical,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
              ["<C-q>"] = send_to_qf_and_open_trouble,
              ["<C-s>"] = open_with_trouble,
              ["<C-a>"] = action_layout.toggle_preview,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<Esc>"] = actions.close,
              ["?"] = actions.which_key,
            },
            n = {
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["v"] = actions.select_vertical,
              ["x"] = actions.select_horizontal,
              ["t"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
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
            disable_devicons = false,
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
            disable_devicons = false,
            find_command = fd_find_command,
          },
          git_files = {
            show_untracked = true,
            disable_devicons = false,
          },
          live_grep = {
            disable_devicons = false,
          },
          grep_string = {
            disable_devicons = false,
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
          ["ui-select"] = {},
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
