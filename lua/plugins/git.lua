-- Git.
--
-- Namespace: <leader>g for repo-level actions, <leader>h for hunks,
-- ]h / [h to navigate hunks.

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- ] forward, [ backward.
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hd", gs.diffthis, "Diff against index")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")

        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")

        map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk (text object)")
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gclog" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status (fugitive)" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gP", "<cmd>Git push<cr>", desc = "Git push" },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
      default_mappings = true, -- co ours, ct theirs, cb both, c0 none, ]x/[x navigate
      disable_diagnostics = true,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      },
    },
  },

  {
    -- Merged into the snacks.nvim spec by lazy.nvim so the whole <leader>g
    -- namespace is visible in one file.
    "folke/snacks.nvim",
    keys = {
      { "<leader>gb", function() Snacks.picker.git_log_line() end, desc = "Git blame line" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open on GitHub", mode = { "n", "v" } },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff (hunks)" },
    },
  },
}
