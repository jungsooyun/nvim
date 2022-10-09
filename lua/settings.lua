-- migrate old init.vim to settings.lua

local g = vim.g
local o = vim.o

o.hidden = true
-- need this in favor of fzf.vim
o.autochdir = true

-- Some servers have issues with backup files, see #649.
-- o.nobackup = true
-- o.writebackup = false

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
o.updatetime = 300

-- 1) read opened files again if changes are occurred outside nvim
-- 2) write a modified buffer on each :next, ...
o.autoread = true
o.autowrite = true

-- use incremental search
o.incsearch = true

-- clipboard sharing
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- tab and indent setting
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true
o.cindent = true

-- turn on line number
o.title = true
o.number = true
-- 가져온 세팅인데 괜찮은지 확인해보기
o.numberwidth = 5
o.cursorline = true

-- cmd('syntax enable')
-- cmd('syntax on')


o.mouse = ''
-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
o.signcolumn = 'auto'



-- --------------------------------------------------------------------------------
-- - Filename completion
-- -
-- -   wildmenu : command-line completion operates in an enhanced mode
-- - wildignore : A file that matches with one of these
-- -              patterns is ignored when completing file or directory names.
-- --------------------------------------------------------------------------------

o.wildmenu = true
o.wildignore = '*.bak,*.o,*.e,*~'

-- theme
o.termguicolors = true
o.background = 'dark'
g.solarized_termtrans = 1

-- needed?
require('lsp')
require('plugins')
