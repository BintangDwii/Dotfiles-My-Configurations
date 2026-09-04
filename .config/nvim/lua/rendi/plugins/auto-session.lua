return {
  "rmagatti/auto-session",
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
    { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session for auto session root dir" },
  },
  config = function()
    require("auto-session").setup({
      auto_restore = true,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
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
      },
    })
  end,
}
