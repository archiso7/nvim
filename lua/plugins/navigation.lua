-- Split/pane navigation and file marks.
--
-- The previous assignment was inverted relative to convention. harpoon held
-- <C-hjkl> and smart-splits was pushed onto <A-hjkl> to avoid the clash, but
-- <C-hjkl> for directional pane movement is the near-universal binding (it is
-- what vim-tmux-navigator established). <C-h> was also shadowing
-- backspace-word in insert mode via a signature-help map.
--
-- Now: <C-hjkl> moves between splits and tmux panes, <A-hjkl> resizes, and
-- harpoon lives on <leader>m plus <leader>1-4.
--
-- Cross-boundary movement into tmux panes needs matching root-table bindings in
-- tmux.conf; without them smart-splits only moves within nvim.

return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {
      at_edge = "stop",
      cursor_follows_swapped_bufs = true,
    },
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Go to left split/pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Go to lower split/pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Go to upper split/pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Go to right split/pane" },

      { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
      { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
      { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
      { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Keymaps declared here rather than in config(), which is what previously
    -- forced this plugin to load eagerly: a keymap defined inside config()
    -- cannot act as its own load trigger.
    keys = function()
      local keys = {
        {
          "<leader>m",
          function() require("harpoon"):list():add() end,
          desc = "Harpoon: mark file",
        },
        {
          "<C-e>",
          function()
            local h = require("harpoon")
            h.ui:toggle_quick_menu(h:list())
          end,
          desc = "Harpoon: menu",
        },
        {
          "<leader>M",
          function()
            local h = require("harpoon")
            h.ui:toggle_quick_menu(h:list())
          end,
          desc = "Harpoon: menu",
        },
      }
      for i = 1, 4 do
        table.insert(keys, {
          "<leader>" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "Harpoon: file " .. i,
        })
      end
      return keys
    end,
    config = function()
      require("harpoon"):setup()
    end,
  },
}
