return {
   "nvim-lualine/lualine.nvim",
   event = "VeryLazy",
   dependencies = { "nvim-tree/nvim-web-devicons" }, -- for filetype icons
   config = function()
      require("lualine").setup({
         options = {
            icons_enabled = true,
            theme = "auto",
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            disabled_filetypes = { "neo-tree", "NvimTree", "lazy" },
            always_divide_middle = true,
            globalstatus = true,
         },
         sections = {
            lualine_a = { { "mode", icon = "" } },
            lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } }, -- path = 1 = relative path
            lualine_x = {
               { "encoding" },
               { "fileformat" },
               { "filetype", icon_only = true },
            },
            lualine_y = { "progress" },
            lualine_z = { { "location", icon = "" } },
         },
         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
         },
         extensions = { "lazy", "quickfix", "fugitive", "man", "nvim-dap-ui" },
      })
   end,
}
