-- Keymaps with no plugin dependency.
--
-- Plugin keymaps live with their plugin so that lazy.nvim can use them as load
-- triggers. Namespace owners:
--   <leader>f  find / pickers        plugins/snacks.lua
--   <leader>g  git                   plugins/git.lua
--   <leader>h  git hunks             plugins/git.lua
--   <leader>c  code / lsp            lsp/attach.lua, plugins/format.lua
--   <leader>x  diagnostic lists      plugins/ui.lua
--   <leader>r  run tests             plugins/work.lua
--   <leader>1-4, <leader>m  harpoon  plugins/navigation.lua
--   <C-hjkl>   split + tmux pane nav plugins/navigation.lua

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- System clipboard. Plain y/p stay on the unnamed register.
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Paste over a selection without clobbering the register.
map("x", "<leader>p", '"_dP', { desc = "Paste over selection (keep register)" })

-- Move the selection and reindent.
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Outdent, keep selection" })
map("v", ">", ">gv", { desc = "Indent, keep selection" })

-- Blank line above/below without leaving normal mode or moving the cursor.
map("n", "<leader>o", "m`o<Esc>``", { desc = "Blank line below" })
map("n", "<leader>O", "m`O<Esc>``", { desc = "Blank line above" })

-- Keep the cursor centred while jumping.
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centred)" })
map("n", "n", "nzzzv", { desc = "Next match (centred)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centred)" })

-- Quickfix / location list.
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Prev quickfix item" })

-- Buffers.
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Toggles. <leader>t is the toggle namespace.
map("n", "<leader>tw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = "Toggle wrap" })

map("n", "<leader>ts", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell" })

map("n", "<leader>td", function()
  local enabled = vim.diagnostic.config().virtual_text ~= false
  vim.diagnostic.config({ virtual_text = not enabled })
  vim.notify("Diagnostic virtual text " .. (enabled and "off" or "on"))
end, { desc = "Toggle diagnostic virtual text" })
