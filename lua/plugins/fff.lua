-- fff.nvim — Rust-backed fuzzy file finder + live grep with frecency, git-aware,
-- typo-resistant. Replaces telescope file-finding + snacks.picker grep.
--
-- Keymaps (project-flavored under <leader>p, matching my muscle memory):
--   <leader>pf / <C-p>   Find files
--   <leader>ps           Live grep (plain by default, <S-Tab> cycles plain/regex/fuzzy)
--   <leader>pz           Fuzzy grep (Smith-Waterman, "mtxlk" matches "mutex_lock")
--   <leader>pw           Grep word under cursor
--
-- Constraint syntax inside the query:
--   git:modified | *.rs | *.{ts,tsx} | src/ | !test/ | src/main.rs
--
-- Commands: :FFFScan :FFFRefreshGit :FFFClearCache :FFFHealth :FFFDebug :FFFOpenLog
return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- Downloads a prebuilt native binary (or builds via local rustup).
    require("fff.download").download_or_build_binary()
  end,
  lazy = false, -- fff self-lazy-initializes via lazy_sync
  opts = {
    prompt = "🔎 ",
    title = "FFFiles",
    max_results = 100,
    lazy_sync = true,
    prompt_vim_mode = true, -- <Esc> enters normal mode in the prompt
    layout = {
      height = 0.85,
      width = 0.85,
      prompt_position = "bottom",
      preview_position = "right",
      preview_size = 0.55,
      path_shorten_strategy = "middle_number",
    },
    preview = {
      enabled = true,
      line_numbers = true,
    },
    frecency = { enabled = true },
    history = { enabled = true },
    git = {
      status_text_color = true, -- colored filenames by git status
    },
    grep = {
      smart_case = true,
      time_budget_ms = 150,
      modes = { "plain", "regex", "fuzzy" },
    },
    -- Debug off in daily use; flip via :FFFDebug
    debug = { enabled = false, show_scores = false },
  },
  keys = {
    { "<leader>pf", function() require("fff").find_files() end, desc = "FFF: Find files" },
    { "<C-p>",      function() require("fff").find_files() end, desc = "FFF: Find files" },
    { "<leader>ps", function() require("fff").live_grep() end, desc = "FFF: Live grep" },
    {
      "<leader>pz",
      function()
        require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
      end,
      desc = "FFF: Fuzzy grep",
    },
    {
      "<leader>pw",
      function()
        require("fff").live_grep({ query = vim.fn.expand("<cword>") })
      end,
      desc = "FFF: Grep word under cursor",
    },
  },
}
