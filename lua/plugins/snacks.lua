return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    gitbrowse = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        -- Exclude Sorbet .rbi files from all searches
        smart = { exclude = { "*.rbi" } },
        files = { exclude = { "*.rbi" } },
      },
    },
    indent = {
      enabled = true,
      animate = {
        enabled = true,
        duration = { step = 2, total = 25 },
      },
    },
    notifier = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    -- File finding + grep are owned by fff.nvim (<leader>pf, <leader>ps, ...).
    -- snacks.picker keeps the slices fff doesn't do: smart cross-source, buffers, LSP.
    { "<leader><leader>", function() Snacks.picker.smart() end,        desc = "Smart (buffers+recent+files)" },
    { "<leader>fb",       function() Snacks.picker.buffers() end,      desc = "Buffers" },
    { "<leader>fs",       function() Snacks.picker.lsp_symbols() end,  desc = "LSP Symbols" },
    { "gd",               function() Snacks.picker.lsp_definitions() end,  desc = "Go to Definition" },
    { "gr",               function() Snacks.picker.lsp_references() end,   desc = "Go to References" },
    { "gi",               function() Snacks.picker.lsp_implementations() end, desc = "Go to Implementation" },
    {
      "<leader>gb",
      function() Snacks.gitbrowse() end,
      desc = "Git Browse (open on GitHub)",
      mode = { "n", "v" },
    },
    {
      "<leader>gB",
      function() Snacks.gitbrowse({ branch = "main" }) end,
      desc = "Git Browse (main branch)",
      mode = { "n", "v" },
    },
  },
}
