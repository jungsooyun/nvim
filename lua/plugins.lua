----------------------------------- OLD Vim Plug
local Plug = require 'plugins.vimplug'

Plug.begin('~/.local/share/nvim/plugged')

-- Theme
Plug 'lifepillar/vim-solarized8'

-- Vista
Plug 'liuchengxu/vista.vim'

-- nvim-tree
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')

-- Modern C++ syntax highlighting
Plug 'bfrg/vim-cpp-modern'

Plug ('ntpeters/vim-better-whitespace',  { commit = '8cf4b2175dd61416c2fe7d3234324a6c59d678de' })
Plug ('junegunn/fzf',                    { tag = '0.18.0', dir = '~/.fzf', ['do'] = vim.fn['fzf#install']})
Plug ('junegunn/fzf.vim',                { commit = 'b31512e2a2d062ee4b6eb38864594c83f1ad2c2f' })

-- nvim env setting
Plug 'neovim/nvim-lspconfig'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

-- nvim-cmp has a lot of dependencies...
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'


Plug.ends()

-- if plugins updated, we need to call PackerCompile
vim.cmd([[augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end]])

----------------------------------- Packer
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'feline-nvim/feline.nvim'
end)

