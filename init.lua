local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

local g = vim.g
local o = vim.opt

g.mapleader = " "
g.maplocalleader = "."

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = { enabled = true },
})

o.completeopt = "menu,menuone,noselect"

o.number = true
o.relativenumber = true
o.hidden = true

o.expandtab = true
o.autoindent = true
o.smartindent = true
o.shiftwidth = 4
o.tabstop = 4

o.splitright = true
o.timeoutlen = 300
o.updatetime = 250

g.encoding = "utf-8"
g.nowrap = true
g.noexpandtab = true

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
