return {
  "akinsho/git-conflict.nvim",
  version = "*",
  event = "BufReadPre",
  opts = {
    default_mappings = true, -- co (ours), ct (theirs), cb (both), c0 (none), ]x/[x (next/prev)
    disable_diagnostics = true, -- auto-disable diagnostics on conflicted buffers
    list_opener = "copen",
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  },
}
