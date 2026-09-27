-- Language server settings. Data only — no side effects, no requires.
--
-- Consumed by plugins/lsp.lua, which does the mason install and the
-- vim.lsp.config/vim.lsp.enable calls.
--
-- Per-entry keys handled by the loader (everything else is passed to
-- vim.lsp.config verbatim):
--   mason = false    do not ask mason to install it (project- or OS-provided)
--   enabled = false  skip the server entirely on this machine

local platform = require("config.platform")
local has_shadowenv = vim.fn.executable("shadowenv") == 1

return {
  lua_ls = {
    settings = {
      Lua = {
        telemetry = { enable = false },
        diagnostics = { disable = { "missing-fields" } },
        hint = { enable = true },
      },
    },
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = true,
        inlayHints = {
          bindingModeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true },
          discardableVariableHints = { enable = true },
          implicitDrops = { enable = true },
          lifetimeElisionHints = { enable = "always", useParameterNames = true },
          maxLength = 40,
          parameterHints = { enable = true },
          reborrowHints = { enable = "always" },
          renderColons = true,
          typeHints = { enable = true },
        },
      },
    },
  },

  vtsls = {
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = { completion = { enableServerSideFuzzyMatch = true } },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = { completeFunctionCalls = true },
      },
    },
  },

  basedpyright = {},

  ruff = {
    init_options = {
      settings = {
        lint = { enable = true },
        format = { enable = true },
      },
    },
  },

  html = {
    filetypes = { "html", "eruby" },
  },

  marksman = {},

  harper_ls = {
    filetypes = { "markdown" },
    settings = {
      ["harper-ls"] = {
        userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
      },
    },
  },

  -- Project-managed through shadowenv rather than mason. Only enabled where
  -- shadowenv exists, otherwise every Ruby buffer reports a failed start.
  ruby_lsp = {
    mason = false,
    enabled = has_shadowenv,
    cmd = { "shadowenv", "exec", "--", "ruby-lsp" },
    cmd_env = { DISABLE_SPRING = "1" },
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = {
      formatter = "rubocop_internal",
      linters = { "rubocop" },
      addonSettings = {
        ["Ruby LSP Rails"] = { enablePendingMigrationsPrompt = false },
      },
    },
  },

  -- Ships with Xcode; not a mason package and not available off macOS.
  sourcekit = {
    mason = false,
    enabled = platform.is_mac,
  },
}
