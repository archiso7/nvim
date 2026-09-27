-- blink.cmp — completion.
--
-- This is a top-level spec. It used to be nested as a dependency of
-- nvim-lspconfig, which is backwards: completion is not downstream of LSP, LSP
-- is one of completion's sources. The nesting meant completion could not load
-- until lspconfig did, and could not be configured without editing the LSP file.
--
-- Capabilities registration lives in plugins/lsp.lua (vim.lsp.config('*')).
--
-- Keys come from the 'enter' preset:
--   <CR>       accept                 (the 'default' preset uses <C-y>)
--   <Tab>      jump forward in snippet, otherwise falls through to indent
--   <C-n>/<C-p>, <Up>/<Down>  select
--   <C-space>  show / toggle documentation
--   <C-k>      toggle signature help
--   <C-e>      cancel

return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "enter" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
          },
        },
      },
      ghost_text = { enabled = false },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = { min_keyword_length = 3 },
        path = { opts = { get_cwd = function(_) return vim.fn.getcwd() end } },
      },
    },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
