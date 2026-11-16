return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session for auto session root dir" },
  },
  config = function()
    local tree_was_visible = false

    require("auto-session").setup({
      auto_restore = true,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      pre_save_cmds = {
        function()
          local api = require("rendi.tree").api()
          if not api then
            return
          end

          tree_was_visible = api.tree.is_visible({ any_tabpage = true })
          if tree_was_visible then
            api.tree.close_in_all_tabs()
          end
        end,
      },
      post_save_cmds = {
        function()
          if tree_was_visible then
            tree_was_visible = false
            require("rendi.tree").open()
          end
        end,
      },
      pre_restore_cmds = {
        function()
          vim.g.defer_lsp_restore = true
        end,
      },
      post_restore_cmds = {
        function()
          vim.defer_fn(function()
            vim.g.defer_lsp_restore = nil

            local servers = vim.g.session_lsp_servers
            if servers then
              vim.lsp.enable(servers)
            end
          end, 500)
        end,
        function()
          vim.defer_fn(function()
            require("rendi.tree").reopen()
          end, 100)
        end,
      },
    })
  end,
}
