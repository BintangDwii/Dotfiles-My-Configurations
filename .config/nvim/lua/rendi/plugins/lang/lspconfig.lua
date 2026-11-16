return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
  },
  config = function()
    local servers = {
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "lua_ls",
      "graphql",
      "emmet_ls",
    }
    vim.g.session_lsp_servers = servers

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local server_options = function(options)
      return vim.tbl_deep_extend("force", {
        capabilities = capabilities,
      }, options or {})
    end

    for _, server in ipairs(servers) do
      vim.lsp.config(server, server_options())
    end

    vim.lsp.config("lua_ls", server_options({
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            -- Scanning every runtime file blocks LuaLS when this config is restored.
            library = { vim.env.VIMRUNTIME },
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    }))

    vim.lsp.config("ts_ls", server_options({
      init_options = {
        plugins = {
          { name = "@vue/typescript-plugin", location = "", languages = { "vue" } },
        },
      },
      settings = {
        typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
        javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
      },
    }))

    vim.lsp.config("emmet_ls", server_options({
      filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact" },
    }))

    vim.lsp.config("tailwindcss", server_options({
      settings = {
        tailwindCSS = {
          includeLanguages = {
            typescriptreact = "javascript",
            javascriptreact = "javascript",
          },
        },
      },
    }))

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_enable = false,
    })

    if not vim.g.defer_lsp_restore then vim.lsp.enable(servers) end
  end,
}
