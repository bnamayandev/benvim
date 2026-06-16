return {
	"mbbill/undotree",
	keys = {
		{ "U", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" },
	},
	init = function()
		vim.g.undotree_WindowLayout = 3
	end,
}
