local M = {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function ()
			require('rose-pine').setup({
				variant = "moon"
			})
			vim.cmd("colorscheme rose-pine")
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function ()
			local ts = require 'nvim-treesitter'
			ts.setup { install_dir = vim.fn.stdpath('data') .. '/site' }
			ts.install {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"python",
				"rust",
				"c3"
			}
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function ()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
			vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		end
	}


}

return M