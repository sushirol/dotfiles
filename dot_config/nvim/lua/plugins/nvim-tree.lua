return {
   "nvim-tree/nvim-tree.lua",
   version = "*",
   dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional for file icons
   },
   config = function()
      require("nvim-tree").setup({
         sort_by = "case_sensitive",
         view = {
            width = 30,
            side = "left",
         },
         renderer = {
            group_empty = true,
         },
         filters = {
            dotfiles = false,
         },
         actions = {
            open_file = {
               quit_on_open = true,
            },
         },
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
      vim.keymap.set("n", "<leader>n", ":NvimTreeFocus<CR>", { silent = true, desc = "Focus NvimTree" })

   end,
}
