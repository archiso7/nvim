-- gx.nvim: smarter URL/link opening
-- Press gx on a URL, GitHub issue, plugin name, or Verdict flag to open it
-- Based on Scott Walkinshaw's config from #vim
return {
  "chrishrb/gx.nvim",
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw's gx
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
  submodules = false,
  opts = {
    handlers = {
      plugin = true,       -- open plugin links (lazy.nvim specs)
      github = true,       -- open github issues/PRs
      package_json = true, -- open npm package pages
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
}
