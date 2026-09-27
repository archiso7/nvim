return {
  "neanias/everforest-nvim",
  priority = 1001, -- must load before snacks.nvim (priority 1000) sets up highlights
  lazy = false,
  config = function()
    require("everforest").setup({
      background = "hard",
    })
    vim.cmd.colorscheme("everforest")
  end,
}
