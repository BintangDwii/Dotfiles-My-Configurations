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
    },

    picker = {
      name = "telescope.nvim",
    },

    callbacks = {
      enter_note = function(_, _)
        local actions = require("obsidian.actions")

        -- Core navigation
        vim.keymap.set("n", "<CR>", actions.smart_action, {
          buffer = true,
          desc = "Obsidian: smart action",
        })

        vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<CR>", {
          buffer = true,
          desc = "Obsidian: follow link",
        })

        vim.keymap.set("n", "]o", function()
          actions.nav_link("next")
        end, {
          buffer = true,
          desc = "Obsidian: next link",
        })

        vim.keymap.set("n", "[o", function()
          actions.nav_link("prev")
        end, {
          buffer = true,
          desc = "Obsidian: previous link",
        })

        -- Checkbox
        vim.keymap.set("n", "<leader>nc", "<cmd>Obsidian toggle_checkbox<CR>", {
          buffer = true,
          desc = "Obsidian: toggle checkbox",
        })

        -- Note navigation
        vim.keymap.set("n", "<leader>nb", "<cmd>Obsidian backlinks<CR>", {
          buffer = true,
          desc = "Obsidian: backlinks",
        })

        vim.keymap.set("n", "<leader>nl", "<cmd>Obsidian links<CR>", {
          buffer = true,
          desc = "Obsidian: links",
        })

        vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian toc<CR>", {
          buffer = true,
          desc = "Obsidian: table of contents",
        })

        vim.keymap.set("n", "<leader>ng", "<cmd>Obsidian tags<CR>", {
          buffer = true,
          desc = "Obsidian: tags",
        })

        -- Note management
        vim.keymap.set("n", "<leader>nr", "<cmd>Obsidian rename<CR>", {
          buffer = true,
          desc = "Obsidian: rename note",
        })

        vim.keymap.set("n", "<leader>nT", "<cmd>Obsidian template<CR>", {
          buffer = true,
          desc = "Obsidian: insert template",
        })

        -- Visual actions
        vim.keymap.set("v", "<leader>nl", "<cmd>Obsidian link<CR>", {
          buffer = true,
          desc = "Obsidian: link selection",
        })

        vim.keymap.set("v", "<leader>nn", "<cmd>Obsidian link_new<CR>", {
          buffer = true,
          desc = "Obsidian: create linked note",
        })

        vim.keymap.set("v", "<leader>ne", "<cmd>Obsidian extract_note<CR>", {
          buffer = true,
          desc = "Obsidian: extract selection",
        })
      end,
    },
  },

  keys = {
    -- These are global commands, so they don't need enter_note.
    {
      "<leader>nn",
      "<cmd>Obsidian new<CR>",
      desc = "Obsidian: new note",
    },

    {
      "<leader>ns",
      "<cmd>Obsidian search<CR>",
      desc = "Obsidian: search",
    },

    {
      "<leader>nq",
      "<cmd>Obsidian quick_switch<CR>",
      desc = "Obsidian: quick switch",
    },

    {
      "<leader>nd",
      "<cmd>Obsidian today<CR>",
      desc = "Obsidian: today's note",
    },

    {
      "<leader>ny",
      "<cmd>Obsidian yesterday<CR>",
      desc = "Obsidian: yesterday",
    },

    {
      "<leader>nY",
      "<cmd>Obsidian tomorrow<CR>",
      desc = "Obsidian: tomorrow",
    },

    {
      "<leader>nw",
      "<cmd>Obsidian workspace<CR>",
      desc = "Obsidian: workspace",
    },

    {
      "<leader>no",
      "<cmd>Obsidian open<CR>",
      desc = "Obsidian: open in app",
    },

    {
      "<leader>ni",
      "<cmd>Obsidian paste_img<CR>",
      desc = "Obsidian: paste image",
    },

    {
      "<leader>nC",
      "<cmd>Obsidian check<CR>",
      desc = "Obsidian: check setup",
    },
  },
}
