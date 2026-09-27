vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", "\"+dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set('n', '<leader>o', 'm`o<Esc>``')
vim.keymap.set('n', '<leader>O', 'm`O<Esc>``')

-- Worktree switcher (cd in-place via git worktree list)
vim.keymap.set("n", "<leader>gw", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  local lines = vim.fn.systemlist("git worktree list")
  local entries = {}
  for _, line in ipairs(lines) do
    local path, branch = line:match("^(%S+)%s+%S+%s+%[(.-)%]")
    if path and branch then
      table.insert(entries, { branch = branch, path = path })
    end
  end

  if #entries == 0 then
    vim.notify("No worktrees found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Switch Worktree",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        return {
          value = e.path,
          display = e.branch .. "  " .. e.path,
          ordinal = e.branch,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel and sel.value then
          vim.cmd("cd " .. sel.value)
          vim.notify("Worktree: " .. sel.value, vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }):find()
end, { desc = "Switch worktree" })
