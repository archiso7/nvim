-- vim-rails + vim-projectionist: jump between implementation and test with :A
-- james.newton's packwerk-aware projections (https://github.com/jameswritescode/dotfiles)
local function build_packwerk_config()
  local cwd = vim.fn.getcwd()

  local function remove_cwd(item)
    return item:sub(#cwd + 2)
  end

  local identifier = "package.yml"
  local glob = vim.glob.to_lpeg(cwd .. "/components/**/" .. identifier)

  local packages = vim.fs.find(function(name, path)
    local matches = glob:match(path .. "/" .. name)
    local depth = #vim.split(remove_cwd(path), "/")
    return matches and depth > 1 and depth < 4
  end, { limit = math.huge, type = "file" })

  local directories = vim.tbl_map(function(item)
    local path = remove_cwd(item)
    return path:sub(1, -#identifier - 1)
  end, packages)

  local config = {}

  for _, dir in pairs(directories) do
    config[dir .. "app/*.rb"] = {
      type = "source",
      alternate = {
        dir .. "test/unit/{}_test.rb",
        dir .. "test/{}_test.rb",
      },
    }
    config[dir .. "app/models/*.rb"] = {
      type = "model",
      alternate = {
        dir .. "test/unit/{}_test.rb",
        dir .. "test/{}_test.rb",
      },
    }
    config[dir .. "test/unit/*_test.rb"] = {
      type = "test",
      alternate = {
        dir .. "app/models/{}.rb",
        dir .. "app/{}.rb",
      },
    }
    config[dir .. "test/*_test.rb"] = {
      type = "test",
      alternate = dir .. "app/{}.rb",
    }
  end

  return config
end

return {
  {
    "tpope/vim-projectionist",
  },
  {
    "tpope/vim-rails",
    dependencies = { "tpope/vim-projectionist" },
    ft = { "ruby", "eruby" },
    config = function()
      -- In monorepo with packwerk, build component-aware projections
      if vim.fn.filereadable(vim.fn.getcwd() .. "/packwerk.yml") == 1 then
        vim.g.rails_projections = build_packwerk_config()
      end
    end,
  },
}
