return {
  "goolord/alpha-nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                     ]],
      [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      [[                                                     ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("n", "  New file", "<cmd>ene <BAR> startinsert<CR>"),
      dashboard.button("l", "  Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }

    dashboard.section.footer.val = "rendi"
    dashboard.section.footer.opts.hl = "Comment"

    alpha.setup(dashboard.opts)
  end,
}
