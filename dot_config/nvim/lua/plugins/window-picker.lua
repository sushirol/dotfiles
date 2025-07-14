return {
	"s1n7ax/nvim-window-picker",
	version = "2.*",
	config = function()
		require("window-picker").setup({
			hint = "floating-big-letter",
			selection_chars = "123456789",
			filter_rules = {
				bo = {
					filetype = { "NvimTree", "neo-tree", "notify" },
					buftype = { "terminal", "quickfix" },
				},
			},
		})

		-- ✅ Add the keymap *here*, inside config
		vim.keymap.set("n", "<leader>w", function()
			local win = require("window-picker").pick_window()
			if win then vim.api.nvim_set_current_win(win) end
		end, { desc = "Pick window" })
	end,
}
