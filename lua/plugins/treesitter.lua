-- Treesitter.
--
-- `branch = "master"` is load-bearing. nvim-treesitter's default branch is now
-- `main`, which removed the `nvim-treesitter.configs` module that the setup
-- call below uses. Without this pin, a fresh clone (no lazy-lock.json) pulls
-- `main` and errors on startup before anything else loads.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "embedded_template",
        "eruby",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "ruby",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
    },
  },
  {
    -- Auto-inserts `end` in ruby/lua. Declares its treesitter dependency, which
    -- it previously relied on load order to satisfy.
    "RRethy/nvim-treesitter-endwise",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "InsertEnter",
    config = function()
      require("nvim-treesitter.configs").setup({ endwise = { enable = true } })
    end,
  },
}
