return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
    },
    current_line_blame = false, -- toggle with <leader>tb
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigate hunks
      map("n", "]h", function()
        if vim.wo.diff then return "]h" end
        gs.next_hunk()
      end, { expr = true, desc = "Next hunk" })
      map("n", "[h", function()
        if vim.wo.diff then return "[h" end
        gs.prev_hunk()
      end, { expr = true, desc = "Prev hunk" })

      -- Stage / reset
      map("n", "<leader>hs", gs.stage_hunk,                    { desc = "Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk,                    { desc = "Reset hunk" })
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
      map("n", "<leader>hS", gs.stage_buffer,                  { desc = "Stage buffer" })
      map("n", "<leader>hu", gs.undo_stage_hunk,               { desc = "Undo stage hunk" })
      map("n", "<leader>hp", gs.preview_hunk,                  { desc = "Preview hunk" })
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
      map("n", "<leader>tb", gs.toggle_current_line_blame,     { desc = "Toggle line blame" })
      map("n", "<leader>hd", gs.diffthis,                      { desc = "Diff this" })
    end,
  },
}
