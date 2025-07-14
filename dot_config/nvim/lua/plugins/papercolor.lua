return {
  "NLKNguyen/papercolor-theme",
  lazy = false,  -- load at startup (since it's a colorscheme)
  priority = 1000,  -- load before other UI plugins
  config = function()
    --[[
       [vim.cmd.colorscheme("PaperColor")
       ]]
    --[[
       [vim.opt.background = 'light'
       ]]
  end,
}
