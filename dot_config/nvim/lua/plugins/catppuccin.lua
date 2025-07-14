return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "latte", -- latte, frappe, macchiato, mocha
    })

    -- Apply colorscheme after setup
    vim.cmd.colorscheme("catppuccin")
  end,
}
