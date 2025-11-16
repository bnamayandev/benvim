-- insert at the start of a line
vim.keymap.set("v", "<leader>gi", function()
	local prefix = vim.fn.input("Prefix to insert: ")
	if prefix ~= "" then
		vim.cmd("'<,'>s/^/" .. prefix:gsub("/", "\\/") .. "/")
	end
end, { noremap = true, silent = true })
