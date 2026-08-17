return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",

  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,

    workspaces = {
      {
        name = "personal",
        path = "~/vaults/personal",
      },
      {
        name = "work",
        path = "~/vaults/work",
      },
      picker = {
        name = "telescope.nvim",
      },
    },

    mappings = {
      -- Follow links / toggle checkboxes / heading folding.
      ["<CR>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = {
          buffer = true,
          expr = true,
        },
      },

      -- Obsidian-aware gf.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = {
          noremap = false,
          expr = true,
          buffer = true,
        },
      },

      -- Toggle checkbox.
      ["<leader>nc"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = {
          buffer = true,
        },
      },

      -- Previous / next Obsidian link.
      ["[o"] = {
        action = function()
          return require("obsidian").util.nav_link(-1)
        end,
        opts = {
          buffer = true,
        },
      },

      ["]o"] = {
        action = function()
          return require("obsidian").util.nav_link(1)
        end,
        opts = {
          buffer = true,
        },
      },
    },
  },

  keys = {
    -- Notes
    {
      "<leader>nn",
      "<cmd>Obsidian new<CR>",
      desc = "New note",
    },

    {
      "<leader>ns",
      "<cmd>Obsidian search<CR>",
      desc = "Search notes",
    },

    {
      "<leader>nq",
      "<cmd>Obsidian quick_switch<CR>",
      desc = "Quick switch note",
    },

    -- Daily notes
    {
      "<leader>nd",
      "<cmd>Obsidian today<CR>",
      desc = "Today's note",
    },

    {
      "<leader>ny",
      "<cmd>Obsidian yesterday<CR>",
      desc = "Yesterday's note",
    },

    {
      "<leader>nY",
      "<cmd>Obsidian tomorrow<CR>",
      desc = "Tomorrow's note",
    },

    {
      "<leader>nD",
      "<cmd>Obsidian dailies<CR>",
      desc = "Browse daily notes",
    },

    -- Navigation / relationships
    {
      "<leader>nb",
      "<cmd>Obsidian backlinks<CR>",
      desc = "Backlinks",
    },

    {
      "<leader>nl",
      "<cmd>Obsidian links<CR>",
      desc = "Links in note",
    },

    {
      "<leader>ntc",
      "<cmd>Obsidian toc<CR>",
      desc = "Table of contents",
    },

    {
      "<leader>ng",
      "<cmd>Obsidian tags<CR>",
      desc = "Browse tags",
    },

    {
      "<leader>nf",
      "<cmd>Obsidian footnotes<CR>",
      desc = "Footnotes",
    },

    -- Note management
    {
      "<leader>nr",
      "<cmd>Obsidian rename<CR>",
      desc = "Rename note",
    },

    {
      "<leader>nT",
      "<cmd>Obsidian template<CR>",
      desc = "Insert template",
    },

    {
      "<leader>nN",
      "<cmd>Obsidian new_from_template<CR>",
      desc = "New note from template",
    },

    -- Obsidian application
    {
      "<leader>no",
      "<cmd>Obsidian open<CR>",
      desc = "Open in Obsidian",
    },

    -- Workspace
    {
      "<leader>nw",
      "<cmd>Obsidian workspace<CR>",
      desc = "Switch workspace",
    },

    -- Images
    {
      "<leader>ni",
      "<cmd>Obsidian paste_img<CR>",
      desc = "Paste image",
    },

    -- Diagnostics / setup
    {
      "<leader>nC",
      "<cmd>Obsidian check<CR>",
      desc = "Check Obsidian setup",
    },

    {
      "<leader>nh",
      "<cmd>Obsidian help<CR>",
      desc = "Obsidian help",
    },

    -- Visual-mode knowledge extraction
    {
      "<leader>ne",
      "<cmd>Obsidian extract_note<CR>",
      mode = "v",
      desc = "Extract selection to note",
    },

    {
      "<leader>nn",
      "<cmd>Obsidian link_new<CR>",
      mode = "v",
      desc = "Create note from selection",
    },

    {
      "<leader>nl",
      "<cmd>Obsidian link<CR>",
      mode = "v",
      desc = "Link selection",
    },
  },
}
