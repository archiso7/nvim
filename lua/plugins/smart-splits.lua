-- smart-splits.nvim: seamless navigation between neovim splits and tmux panes
-- Uses <A-hjkl> to avoid conflicting with harpoon's <C-hjkl>
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    require("smart-splits").setup()

    -- Move between splits/panes (works across neovim + tmux)
    vim.keymap.set("n", "<A-h>", require("smart-splits").move_cursor_left,  { desc = "Move to left split" })
    vim.keymap.set("n", "<A-j>", require("smart-splits").move_cursor_down,  { desc = "Move to lower split" })
    vim.keymap.set("n", "<A-k>", require("smart-splits").move_cursor_up,    { desc = "Move to upper split" })
    vim.keymap.set("n", "<A-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })

    -- Resize splits
    vim.keymap.set("n", "<A-Left>",  require("smart-splits").resize_left,  { desc = "Resize left" })
    vim.keymap.set("n", "<A-Down>",  require("smart-splits").resize_down,  { desc = "Resize down" })
    vim.keymap.set("n", "<A-Up>",    require("smart-splits").resize_up,    { desc = "Resize up" })
    vim.keymap.set("n", "<A-Right>", require("smart-splits").resize_right, { desc = "Resize right" })
  end,
}
