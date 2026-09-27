-- Language servers.
--
-- On nvim 0.11 the native vim.lsp.config/vim.lsp.enable API is the control
-- plane. mason is an installer only: `automatic_enable = false` is essential,
-- because otherwise mason-lspconfig enables every installed mason package that
-- happens to have an lspconfig entry — which is how `stylua --lsp` ended up
-- attached to Lua buffers as a phantom language server.
--
-- Server settings live in lua/lsp/servers.lua. Keymaps live in lua/lsp/attach.lua.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local servers = require("lsp.servers")

      require("lsp.attach").setup()

      vim.diagnostic.config({
        virtual_text = { spacing = 2, source = "if_many" },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
        },
      })

      -- blink.cmp advertises capabilities nvim does not enable by default:
      -- resolveSupport for additionalTextEdits (this is what makes LSP
      -- auto-import work on accept), insertReplaceSupport (without it,
      -- completing over a partial word appends instead of replacing) and
      -- labelDetailsSupport. Registering against '*' covers every server.
      -- get_lsp_capabilities(override, include_nvim_defaults): the second
      -- argument must be true, otherwise nvim's defaults are dropped. Passing
      -- nvim's defaults as `override` instead makes them clobber blink's.
      local ok_blink, blink = pcall(require, "blink.cmp")
      local capabilities = ok_blink and blink.get_lsp_capabilities({}, true)
        or vim.lsp.protocol.make_client_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      local mason_ensure = {}
      for name, cfg in pairs(servers) do
        if cfg.enabled ~= false and cfg.mason ~= false then
          table.insert(mason_ensure, name)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = mason_ensure,
        automatic_enable = false,
      })

      for name, cfg in pairs(servers) do
        if cfg.enabled ~= false then
          local settings = vim.deepcopy(cfg)
          settings.mason = nil
          settings.enabled = nil
          vim.lsp.config(name, settings)
          vim.lsp.enable(name)
        end
      end
    end,
  },
}
