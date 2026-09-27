-- conform.nvim — the single owner of formatting.
--
-- Previously there were three owners: conform's format_on_save (all
-- filetypes), plus BufWritePre autocmds for *.rs and *.rb that called
-- vim.lsp.buf.format directly, so Ruby and Rust files were formatted twice per
-- save. ERB was worse: a BufWritePost hook shelled out to `bundle list` and
-- `which` synchronously on every write, freezing the UI for seconds in a
-- monorepo. conform ships an htmlbeautifier formatter, so that is now declarative.
--
-- Filetypes with no entry below fall through to the LSP formatter, which is how
-- Ruby (ruby_lsp + rubocop_internal) and Rust (rust_analyzer) are handled.
--
-- Namespace: <leader>cf

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    -- Defined here rather than inside config(), so it exists before the first
    -- write. It previously lived in config() with a BufWritePre load trigger,
    -- meaning the keymap did not exist until you had already saved once.
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      eruby = { "htmlbeautifier" },
      python = { "ruff_organize_imports", "ruff_format" },
      sh = { "shfmt" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command("FormatToggle", function(args)
      if args.bang then
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify("Buffer autoformat " .. (vim.b.disable_autoformat and "off" or "on"))
      else
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Global autoformat " .. (vim.g.disable_autoformat and "off" or "on"))
      end
    end, { bang = true, desc = "Toggle autoformat (! for buffer only)" })
  end,
}
