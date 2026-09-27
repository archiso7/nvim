return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Ruby formatting is handled by ruby_lsp (rubocop_internal) via vim.lsp.buf.format
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })

    vim.keymap.set("n", "<leader>gf", function()
      require("conform").format({ async = true })
    end, { desc = "Format file" })
  end,
}
