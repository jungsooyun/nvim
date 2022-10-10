-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require('plugins')
require('settings')
require('lsp')
require('autocmd')
require('nvim-cmp')
require('keymaps')
require('load-plugins')
