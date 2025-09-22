return {
  'altermo/ultimate-autopair.nvim',
    config = function ()
      require("ultimate-autopair").setup()
    end,
  event={'InsertEnter','CmdlineEnter'},
  branch='v0.6',
}
