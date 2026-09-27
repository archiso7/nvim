-- Editing behaviour.
--
-- tabout.nvim was removed here. It mapped <Tab> to jump out of pairs, which
-- collided with blink.cmp's <Tab>, and its `completion = true` option works by
-- checking vim.fn.pumvisible() — an nvim-cmp-era assumption. blink draws its
-- own window and never sets pumvisible, so tabout's completion awareness was a
-- no-op and Tab behaviour with the menu open was undefined.
-- ultimate-autopair's fastwarp covers the same ground without touching <Tab>.

return {
  {
    "altermo/ultimate-autopair.nvim",
    branch = "v0.6",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- <A-e> warps the next closing pair to after the cursor.
      fastwarp = { enable = true },
      close = { enable = true },
      cr = { enable = true },
    },
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
    end,
  },

  {
    -- gx on a URL, GitHub issue, plugin spec, or npm package opens the right
    -- thing. The Shopify feature-flag handler lives in plugins/work.lua.
    "chrishrb/gx.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Browse" },
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open link under cursor" },
    },
    submodules = false,
    init = function()
      vim.g.netrw_nogx = 1
    end,
    opts = {
      handlers = {
        plugin = true,
        github = true,
        package_json = true,
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunk" },
        { "<leader>c", group = "code" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>t", group = "toggle" },
        { "<leader>r", group = "run tests" },
        { "<leader>b", group = "buffer" },
      },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = true }) end,
        desc = "Show all keymaps",
      },
    },
  },
}
