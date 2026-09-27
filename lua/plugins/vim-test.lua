return {
  "janko-m/vim-test",
  keys = {
    { "<leader>rf", "<cmd>TestNearest<cr>", desc = "Run nearest test" },
    { "<leader>rb", "<cmd>TestFile<cr>",    desc = "Run test file" },
    { "<leader>ra", "<cmd>TestSuite<cr>",   desc = "Run test suite" },
    { "<leader>rl", "<cmd>TestLast<cr>",    desc = "Run last test" },
  },
  config = function()
    -- Open results in a split rather than replacing the buffer
    vim.g["test#strategy"] = "neovim"
    vim.g["test#neovim#start_normal"] = 1

    -- Ruby: always use bundle exec for rspec
    vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"

    -- Minitest: use bin/test if present (monorepo), else bundle exec ruby -Itest
    if vim.fn.filereadable(vim.fn.getcwd() .. "/bin/test") == 1 then
      vim.g["test#ruby#minitest#executable"] = "bin/test"
    else
      vim.g["test#ruby#minitest#executable"] = "bundle exec ruby -Itest"
    end

    -- Save all buffers before running
    vim.api.nvim_create_autocmd("User", {
      pattern = "TestRunPre",
      command = "wall",
    })
  end,
}
