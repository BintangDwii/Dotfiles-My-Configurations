return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fB",
        function()
          local telescope = require("telescope")
          local current_dir = vim.fn.expand("%:p:h")

          if current_dir == "" then
            current_dir = vim.uv.cwd()
          end

          telescope.load_extension("file_browser")
          telescope.extensions.file_browser.file_browser({
            hidden = true,
            respect_gitignore = true,
            git_status = false,
            previewer = true,
            path = current_dir,
            cwd = current_dir,
            grouped = true,
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
        preview = true,
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
