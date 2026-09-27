-- snacks.nvim — the single picker, plus the small QoL modules.
--
-- This replaces what used to be three overlapping search systems: telescope
-- (deleted, but its keymap survived and threw on every press), fff.nvim on
-- <leader>p*, and snacks.picker on <leader>f*. One picker, one namespace.
--
-- Requires `ripgrep` and `fd` on PATH. Neither was installed before, which is
-- the real reason a second picker with a bundled binary looked attractive.
--
-- Namespace: <leader>f find, <leader>e explorer, <leader><leader> smart.

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    words = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },
    },
    input = { enabled = true },
    gitbrowse = { enabled = true },
    picker = {
      enabled = true,
      layout = { preset = "default" },
      formatters = { file = { filename_first = true } },
      sources = {
        explorer = { hidden = true },
        -- Sorbet type stubs are generated noise in the Ruby monorepo.
        files = { hidden = true, exclude = { "*.rbi" } },
        grep = { exclude = { "*.rbi" } },
        smart = { exclude = { "*.rbi" } },
      },
    },
    styles = {
      notification = { wo = { wrap = true } },
    },
  },
  keys = {
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart find (buffers + recent + files)" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },

    -- Find
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep (live)" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fl", function() Snacks.picker.lines() end, desc = "Lines in buffer" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (workspace)" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
    { "<leader>fR", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    {
      "<leader>fc",
      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find in nvim config",
    },

    -- Scratch buffer
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
  },
}
