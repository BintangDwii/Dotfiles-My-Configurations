return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "rayliwell/tree-sitter-rstml",
  },
  config = function()
    local languages = {
      "json",
      "javascript",
      "java",
      "typescript",
      "tsx",
      "rust",
      "rust_with_rstml",
      "asm",
      "yaml",
      "html",
      "css",
      "prisma",
      "hurl",
      "python",
      "markdown",
      "markdown_inline",
      "graphql",
      "php",
      "bash",
      "lua",
      "vim",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "smali",
    }

    require("nvim-treesitter").setup()

    require("tree-sitter-rstml").setup()

    require("nvim-treesitter").install(languages)

    local non_rust_languages = vim.tbl_filter(function(lang)
      return lang ~= "rust" and lang ~= "rust_with_rstml"
    end, languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = non_rust_languages,
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function(args)
        pcall(vim.treesitter.stop, args.buf)
        pcall(vim.treesitter.start, args.buf, "rust_with_rstml")
      end,
    })

    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })
  end,
}
