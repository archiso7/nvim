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

      local ensure_installed = vim.tbl_keys(servers or {})

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
      })

      for server, settings in pairs(servers) do
        vim.lsp.config(server, settings)
        vim.lsp.enable(server)
      end

      -- Setup ruby-lsp for Ruby files (respects shadowenv/bundler)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "ruby", "eruby" },
        callback = function()
          local root_dir = vim.fs.dirname(vim.fs.find({ "Gemfile", ".git" }, { upward = true })[1])
          
          -- Determine command: use bundle exec if in Gemfile, otherwise direct
          -- Direct call will still respect shadowenv's Ruby version and gems
          local cmd
          if root_dir and vim.fn.filereadable(root_dir .. "/Gemfile") == 1 then
            -- Check if ruby-lsp is in bundle by running bundle list
            local handle = io.popen("cd " .. root_dir .. " && bundle list 2>/dev/null | grep 'ruby-lsp'")
            local result = handle:read("*a")
            handle:close()
            
            if result and result ~= "" then
              cmd = { "bundle", "exec", "ruby-lsp" }
            else
              -- Not in bundle, use gem directly (respects shadowenv Ruby)
              cmd = { "ruby-lsp" }
            end
          else
            -- No Gemfile, use gem directly
            cmd = { "ruby-lsp" }
          end
          
          vim.lsp.start({
            name = "ruby_lsp",
            cmd = cmd,
            root_dir = root_dir,
            init_options = {
              enabledFeatures = {
                "documentHighlights",
                "documentSymbols",
                "foldingRanges",
                "selectionRanges",
                "semanticHighlighting",
                "formatting",
                "codeActions",
                "diagnostics",
                "hover",
                "completion",
                "definition",
                "workspaceSymbol",
                "signatureHelp",
              },
            },
          })
        end,
      })

      --Setup RuboCop as an LSP for Ruby files (not ERB - RuboCop can't parse ERB)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        callback = function()
          local root_dir = vim.fs.dirname(vim.fs.find({ ".rubocop.yml", ".git"  }, { upward = true  })[1])
          
          -- Check if rubocop is in the bundle
          local cmd
          if root_dir and vim.fn.filereadable(root_dir .. "/Gemfile") == 1 then
            local handle = io.popen("cd " .. root_dir .. " && bundle list 2>/dev/null | grep 'rubocop'")
            local result = handle:read("*a")
            handle:close()
            
            if result and result ~= "" then
              cmd = { "bundle", "exec", "rubocop", "--lsp" }
            else
              cmd = { "rubocop", "--lsp" }
            end
          else
            cmd = { "rubocop", "--lsp" }
          end
          
          vim.lsp.start({
            name = "rubocop",
            cmd = cmd,
            root_dir = root_dir,
          })
        end,
      })

      -- Auto-format Ruby files on save with RuboCop (only .rb files)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rb",
        callback = function()
          vim.lsp.buf.format({ timeout_ms = 5000  })
        end,
      })

      -- Auto-format ERB files after save with htmlbeautifier
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.erb",
        callback = function()
          local file = vim.api.nvim_buf_get_name(0)
          local root_dir = vim.fs.dirname(vim.fs.find({ "Gemfile", ".git" }, { upward = true })[1])
          
          -- Check if htmlbeautifier is in bundle or available
          local cmd = "htmlbeautifier"
          if root_dir and vim.fn.filereadable(root_dir .. "/Gemfile") == 1 then
            local handle = io.popen("cd " .. root_dir .. " && bundle list 2>/dev/null | grep 'htmlbeautifier'")
            local result = handle:read("*a")
            handle:close()
            
            if result and result ~= "" then
              cmd = "bundle exec htmlbeautifier"
            end
          end
          
          -- Check if htmlbeautifier is actually available before running
          local check_cmd = cmd == "htmlbeautifier" and "which htmlbeautifier" or "bundle exec htmlbeautifier --version"
          local available = vim.fn.system(check_cmd)
          
          if vim.v.shell_error == 0 then
            -- Format the file and reload
            vim.cmd("silent !" .. cmd .. " " .. vim.fn.shellescape(file))
            vim.cmd("checktime")
          end
        end,
      })

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
