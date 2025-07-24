local map = vim.keymap.set
local opts = {
	noremap = true,
	silent = true,
}

map("i", "jk", "<esc>")

map("n", "<Esc>", "<Cmd>noh<CR>")
map("n", ";", ":")

map("", "H", "^")
map("", "L", "$")

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

map("", "<C-h>", "<C-w>h", opts)
map("", "<C-j>", "<C-w>j", opts)
map("", "<C-k>", "<C-w>k", opts)
map("", "<C-l>", "<C-w>l", opts)