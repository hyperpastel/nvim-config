local M = {
	{ "Airbus5717/c3.vim" },
	{
		"lervag/vimtex",
		lazy = false,
		config = function ()
			vim.g.vimtex_view_method = "zathura"
		end,
	},
}

return M