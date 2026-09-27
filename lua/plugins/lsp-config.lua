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
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = true,
              inlayHints = {
                enable = true,
                bindingModeHints = {
                  enable = true,
                },
                chainingHints = {
                  enable = true,
                },
                closingBraceHints = {
                  enable = true,
                },
                discardableVariableHints = {
                  enable = true,
                },
                implicitDrops = {
                  enable = true,
                },
                lifetimeElisionHints = {
                  enable = "always",
                  useParameterNames = true,
                },
                maxLength = 40,
                parameterHints = {
                  enable = true,
                },
                reborrowHints = {
                  enable = "always",
                },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
            },
          },
        },
        harper_ls = {
          filetypes = { "markdown" },
          settings = {
            ["harper-ls"] = {
              userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
            },
          },
        },
        html = {
          filetypes = { "html", "eruby" },
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

      -- ruby_lsp is project-managed via shadowenv, not mason
      vim.lsp.config("ruby_lsp", {
        cmd = { "shadowenv", "exec", "--", "ruby-lsp" },
        cmd_env = { DISABLE_SPRING = "1" },
        filetypes = { "ruby", "eruby" },
        root_markers = { "Gemfile", ".git" },
        init_options = {
          formatter = "rubocop_internal",
          linters = { "rubocop" },
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
          experimentalFeaturesEnabled = true,
        },
      })
      vim.lsp.enable("ruby_lsp")

      local ensure_installed = vim.tbl_keys(servers or {})

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })

      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end

      -- Auto-format ERB files after save with htmlbeautifier
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.erb",
        callback = function()
          local file = vim.api.nvim_buf_get_name(0)
          local root_dir = vim.fs.dirname(vim.fs.find({ "Gemfile", ".git" }, { upward = true })[1])

          -- Check if htmlbeautifier is in bundle or available
          local cmd = "htmlbeautifier"
          if root_dir and vim.fn.filereadable(root_dir .. "/Gemfile") == 1 then
            local handle =
                io.popen("cd " .. root_dir .. " && bundle list 2>/dev/null | grep 'htmlbeautifier'")
            local result = handle:read("*a")
            handle:close()

            if result and result ~= "" then
              cmd = "bundle exec htmlbeautifier"
            end
          end

          -- Check if htmlbeautifier is actually available before running
          local check_cmd = cmd == "htmlbeautifier" and "which htmlbeautifier"
              or "bundle exec htmlbeautifier --version"
          local available = vim.fn.system(check_cmd)

          if vim.v.shell_error == 0 then
            -- Format the file and reload
            vim.cmd("silent !" .. cmd .. " " .. vim.fn.shellescape(file))
            vim.cmd("checktime")
          end
        end,
      })

      -- Auto-format Rust files on save with rustfmt
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 5000 })
        end,
      })

      -- not included in mason lsp config
      vim.lsp.enable("sourcekit")
      -- Auto-format Ruby files on save via ruby_lsp (rubocop_internal)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rb",
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 5000 })
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
      })
      vim.keymap.set("n", "<leader>td", function()
        local current = vim.diagnostic.config()
        vim.diagnostic.config({ virtual_text = not current.virtual_text })
      end, { desc = "Toggle diagnostic virtual text" })
      vim.keymap.set("n", "K",            vim.lsp.buf.hover,              { desc = "Hover docs" })
      vim.keymap.set("n", "<leader>ca",   vim.lsp.buf.code_action,        { desc = "Code action" })
      vim.keymap.set("n", "<leader>vws",  vim.lsp.buf.workspace_symbol,   { desc = "Workspace symbol" })
      vim.keymap.set("n", "<leader>vd",   vim.diagnostic.open_float,      { desc = "Diagnostic float" })
      vim.keymap.set("n", "<leader>vrn",  vim.lsp.buf.rename,             { desc = "Rename symbol" })
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1 }) end,  { desc = "Next diagnostic" })
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })
      -- gd / gr / gi are handled by snacks.picker (see snacks.lua)
    end,
  },
}
