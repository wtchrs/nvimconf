return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "c",
        "comment",
        "cpp",
        "css",
        "glimmer",
        "go",
        "html",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "markdown",
        "markdown_inline",
        "lua",
        "python",
        "query",
        "rst",
        "rust",
        "yaml",
        "svelte",
        "tsx",
        "typescript"
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
      autotag = { enable = true },
      matchup = { enable = true },
      playground = { enable = true },

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  }
}
