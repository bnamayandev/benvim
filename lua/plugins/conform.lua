return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	init = function()
		vim.api.nvim_create_user_command("Format", function()
			require("conform").format()
		end, {})

		vim.api.nvim_create_user_command("FormatAll", function()
			local conform = require("conform")
			local cwd = vim.fn.getcwd()
			local files = vim.fn.systemlist({ "rg", "--files", cwd })
			local changed = 0

			for _, path in ipairs(files) do
				local ft = vim.filetype.match({ filename = path })
				if ft and conform.formatters_by_ft[ft] then
					local was_loaded = vim.fn.bufloaded(path) == 1
					local buf = vim.fn.bufadd(path)

					if not was_loaded then
						local ei = vim.o.eventignore
						vim.o.eventignore = "all"
						vim.fn.bufload(buf)
						vim.bo[buf].filetype = ft
						vim.o.eventignore = ei
					end

					if #conform.list_formatters(buf) > 0 then
						conform.format({ bufnr = buf, lsp_format = "never", timeout_ms = 5000 })
						if vim.bo[buf].modified then
							changed = changed + 1
							if not was_loaded then
								vim.api.nvim_buf_call(buf, function()
									vim.cmd("silent noautocmd write")
								end)
							end
						end
					end

					if not was_loaded then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end
			end

			vim.notify(("FormatAll: %d of %d files changed"):format(changed, #files))
		end, {})
	end,
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			rust = { "rustfmt" },
			cs = { "csharpier" },
			java = { "google-java-format" },
			go = { "gofmt" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
	},
}
