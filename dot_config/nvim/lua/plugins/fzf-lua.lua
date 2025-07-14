return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {
    oldfiles = {
      -- In Telescope, when I used <leader>fr, it would load old buffers.
      -- fzf lua does the same, but by default buffers visited in the current
      -- session are not included. I use <leader>fr all the time to switch
      -- back to buffers I was just in. If you missed this from Telescope,
      -- give it a try.
      include_current_session = true,
    },
  },
  config = function()
    require("fzf-lua").setup({}) -- your setup

    -- Add your keymap here
    vim.keymap.set("n", "<leader>f", function()
      require("fzf-lua").files({ hidden = true })
    end, { silent = true, desc = "FZF: Files (with hidden)" })

    vim.keymap.set("n", "<leader>b", function()
      require("fzf-lua").buffers({
        sort_lastused = true,
        previewer = true,
      })
    end, { silent = true, desc = "FZF: Buffers (sorted)" })

    vim.keymap.set("n", "S", function()
      require("fzf-lua").grep({ search = vim.fn.expand("<cword>") })
    end, { silent = true, desc = "FZF: Grep word under cursor" })

    vim.keymap.set("n", "<leader>sl", function()
      require("fzf-lua").blines({
        previewer = false, prompt = "Lines > ",
        winopts = { height = 0.5, width = 0.9, row = 0.4, },
      })
    end, { silent = true, desc = "FZF: Buffer Lines" })

    vim.keymap.set("n", "<leader>s?", function()
      require("fzf-lua").command_history({
        prompt = "Cmd History > ",
        winopts = { height = 0.6, width = 0.85, row = 0.3, },
      })
    end, { silent = true, desc = "FZF: Command History" })

    vim.keymap.set("n", "<leader>ss", function()
      local ok, input = pcall(vim.fn.input, "🔍 Search > ")
      if not ok or input == "" then return end
      require("fzf-lua").grep({
        search = input,
        prompt = "Rg > ",
        winopts = {
          height = 0.6,
          width = 0.85,
          row = 0.2,
          col = 0.1,
          preview = {
            vertical = "up:60%",  -- preview on top
          },
        },
        fzf_opts = {
          ["--ansi"] = "",
          ["--exact"] = "",
          ["--layout"] = "reverse",
        }
      })
    end, { desc = "FZF: Search string" })


  end,

}
