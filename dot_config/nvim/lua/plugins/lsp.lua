return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local Methods = vim.lsp.protocol.Methods

				if client.supports_method(Methods.textDocument_completion) then
					vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
				end

				if client.supports_method(Methods.textDocument_documentHighlight, event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("my-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("my-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds { group = "my-lsp-attach", buffer = event2.buf }
						end,
					})
				end

				if client.supports_method(Methods.textDocument_inlayHint, event.buf) then
					vim.lsp.inlay_hint.enable(true)
				end

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					callback = function()
						local wins = vim.api.nvim_tabpage_list_wins(0)
						for _, win in ipairs(wins) do
							if vim.api.nvim_win_get_config(win).relative ~= "" then return end
						end
						vim.diagnostic.open_float { scope = "cursor" }
					end,
				})
			end,
		})

		vim.diagnostic.config {
			severity_sort = true,
			virtual_text = true,
		}

		local lspconfig = require("lspconfig")

		lspconfig.pyright.setup {
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = function() return "/src" end,
			filetypes = { "python" },
		}

		vim.api.nvim_create_user_command("GenerateCompileDb", function()
			local paths = vim.split(vim.fn.system("ls /bld"), "\n")
			local built_pkgs = {}
			for _, path in ipairs(paths) do
				if vim.fn.isdirectory("/src/" .. path) == 1 then
					table.insert(built_pkgs, path)
				end
			end
			vim.fn.system("cdbgen --tin " .. table.concat(built_pkgs, " "))
		end, { desc = "Generate compile DB" })
	end,
}
