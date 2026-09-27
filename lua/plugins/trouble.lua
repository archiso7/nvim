return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (workspace)" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols" },
    { "<leader>xl", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP definitions/references" },
  },
  opts = {
    modes = {
      diagnostics = {
        auto_close = true,
      },
    },
  },
}
