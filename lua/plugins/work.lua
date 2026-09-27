-- Shopify-specific plugins.
--
-- Everything here is guarded by `cond`, evaluated at startup. On a machine
-- without the work toolchain these specs are inert: nothing is cloned, nothing
-- loads, no errors. Previously shadowenv.vim was `lazy = false` and ruby_lsp
-- was wired to `shadowenv exec`, so a personal machine got a failed
-- language-server start on every Ruby buffer, and pi-tmux pointed at a
-- hardcoded /Users/liamwest path that does not exist off the work laptop.
--
-- Namespace: <leader>r for running tests.

local has_shadowenv = vim.fn.executable("shadowenv") == 1
local has_dev = vim.fn.isdirectory("/opt/dev") == 1
local is_work = has_shadowenv or has_dev

local pi_tmux_path = vim.fn.expand("~/.config/shopify-ai-dev/packages/nvim-plugin")
local has_pi_tmux = vim.fn.isdirectory(pi_tmux_path) == 1

return {
  {
    "Shopify/shadowenv.vim",
    cond = has_shadowenv,
    event = "VeryLazy",
  },

  {
    "tpope/vim-projectionist",
    cond = is_work,
    lazy = true,
  },

  {
    -- :A jumps between implementation and test. In a packwerk monorepo the
    -- default rails projections do not understand components/, so they are
    -- rebuilt per-package.
    "tpope/vim-rails",
    cond = is_work,
    dependencies = { "tpope/vim-projectionist" },
    ft = { "ruby", "eruby" },
    config = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. "/packwerk.yml") ~= 1 then
        return
      end

      local identifier = "package.yml"
      local glob = vim.glob.to_lpeg(cwd .. "/components/**/" .. identifier)

      local function remove_cwd(item)
        return item:sub(#cwd + 2)
      end

      local packages = vim.fs.find(function(name, path)
        local matches = glob:match(path .. "/" .. name)
        local depth = #vim.split(remove_cwd(path), "/")
        return matches and depth > 1 and depth < 4
      end, { limit = math.huge, type = "file" })

      local projections = {}
      for _, item in ipairs(packages) do
        local dir = remove_cwd(item):sub(1, -#identifier - 1)
        projections[dir .. "app/*.rb"] = {
          type = "source",
          alternate = { dir .. "test/unit/{}_test.rb", dir .. "test/{}_test.rb" },
        }
        projections[dir .. "app/models/*.rb"] = {
          type = "model",
          alternate = { dir .. "test/unit/{}_test.rb", dir .. "test/{}_test.rb" },
        }
        projections[dir .. "test/unit/*_test.rb"] = {
          type = "test",
          alternate = { dir .. "app/models/{}.rb", dir .. "app/{}.rb" },
        }
        projections[dir .. "test/*_test.rb"] = {
          type = "test",
          alternate = dir .. "app/{}.rb",
        }
      end
      vim.g.rails_projections = projections
    end,
  },

  {
    "janko-m/vim-test",
    keys = {
      { "<leader>rf", "<cmd>TestNearest<cr>", desc = "Run nearest test" },
      { "<leader>rb", "<cmd>TestFile<cr>", desc = "Run tests in file" },
      { "<leader>ra", "<cmd>TestSuite<cr>", desc = "Run test suite" },
      { "<leader>rl", "<cmd>TestLast<cr>", desc = "Re-run last test" },
      { "<leader>rv", "<cmd>TestVisit<cr>", desc = "Visit last test file" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#start_normal"] = 1
      vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"

      -- The monorepo provides bin/test; standalone gems do not.
      if vim.fn.filereadable(vim.fn.getcwd() .. "/bin/test") == 1 then
        vim.g["test#ruby#minitest#executable"] = "bin/test"
      else
        vim.g["test#ruby#minitest#executable"] = "bundle exec ruby -Itest"
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "TestRunPre",
        command = "wall",
      })
    end,
  },

  {
    -- Send buffers/selections to a pi or claude pane over tmux.
    "MSmaili/wiremux.nvim",
    cond = vim.env.TMUX ~= nil,
    event = "VeryLazy",
    opts = {
      targets = {
        definitions = {
          pi = { kind = "window", cmd = "pi" },
          claude = { kind = "window", cmd = "claude" },
        },
      },
    },
  },

  {
    -- Local plugin from the shopify-ai-dev repo. Path is derived rather than
    -- hardcoded, and the spec is skipped when the repo is not checked out.
    dir = pi_tmux_path,
    name = "pi-tmux",
    cond = has_pi_tmux,
    event = "VeryLazy",
    config = true,
  },

  {
    -- Adds a gx handler for Shopify feature flags. Merged into the gx.nvim
    -- spec in plugins/editor.lua by lazy.nvim.
    "chrishrb/gx.nvim",
    cond = is_work,
    opts = {
      handlers = {
        verdict_flag = {
          name = "verdict_flag",
          handle = function(mode, line, _)
            local flag = require("gx.helper").find(line, mode, '"(f_[^"]+)"')
            if flag then
              return "https://experiments.shopify.com/flags/" .. flag
            end
          end,
        },
      },
    },
  },
}
