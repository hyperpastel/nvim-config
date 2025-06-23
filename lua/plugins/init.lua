local M = {
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function ()
			require('everforest').setup({
				background = "hard";
			})
			vim.cmd([[colorscheme everforest]])
		end,
	}
}

return M