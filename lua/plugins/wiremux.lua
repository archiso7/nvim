return {
  "MSmaili/wiremux.nvim",
  config = function()
    require("wiremux").setup({
      targets = {
        definitions = {
          pi = {
            kind = "window",
            cmd = "pi",
          },
          claude = {
            kind = "window",
            cmd = "claude",
          },
        },
      },
    })
  end,
}
