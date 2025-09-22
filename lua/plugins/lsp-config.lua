return {
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config by
      -- lazily updating your workspace libraries.
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },

      {
        "saghen/blink.cmp",
        enabled = true,
        -- dev = true,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
          keymap = { preset = "default" },

          completion = {
            -- Disable showing for all alphanumeric keywords by default. Prefer LSP specific trigger
            -- characters.
            -- trigger = { show_on_keyword = false },
            -- Controls whether the documentation window will automatically show when selecting a completion item
            documentation = { auto_show = true },
          },

          signature = { enabled = true },
        },
      },
    },
    config = function()
      local servers = {
        harper_ls = {
          filetypes = { "markdown" },
          settings = {
            ["harper-ls"] = {
              userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
            },
          },
        },
        basedpyright = {},
        marksman = {},
        ruff = {
          init_options = {
            settings = {
              lint = { enable = true },
              format = { enable = true },
            },
          },
        },
        sorbet = {
          cmd = { "srb", "tc", "--lsp"  },
          filetypes = { "ruby"  },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("sorbet/config")(fname)
          end,
        },
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              telemetry = { enable = false },
              -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
              hint = { enable = true },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })

      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end

      -- not included in mason lsp config
      vim.lsp.enable("sourcekit")
      vim.diagnostic.config({
        virtual_text = true,
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, {})
      vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = 1 })
      end, {})
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = -1 })
      end, {})
      vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})
    end,
  },
}
