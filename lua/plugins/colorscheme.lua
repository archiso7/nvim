-- everforest — the only place a colorscheme is set.
--
-- It used to be set twice: once here, and again by after/plugin/colors.lua,
-- which is a packer-era pattern that runs after all startup plugins and so
-- fights lazy loading. That double-set raced snacks.nvim's highlight setup,
-- which is why the old spec carried `priority = 1001` and a comment explaining
-- it. With a single owner the priority hack is unnecessary.

return {
  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("everforest").setup({
      background = "hard",
      transparent_background_level = 0,
      italics = true,
      disable_italic_comments = false,
    })
    vim.cmd.colorscheme("everforest")
  end,
}
