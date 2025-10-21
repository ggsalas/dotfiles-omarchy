return {
	"ribru17/bamboo.nvim",
	lazy = false,
	priority = 1000,
	config = function(opts)
		vim.o.termguicolors = true
		vim.opt.background = "dark"

		require("bamboo").setup(opts)
		require("bamboo").load()
	end,
}
