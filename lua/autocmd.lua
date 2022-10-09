-- theme
vim.cmd[[autocmd vimenter * ++nested colorscheme solarized8_flat]]

-- yaml
vim.cmd[[autocmd FileType yml setlocal shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType yaml setlocal shiftwidth=2 tabstop=2]]

-- html/css
vim.cmd[[autocmd FileType html setlocal shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType css setlocal shiftwidth=2 tabstop=2]]

-- c/cpp
vim.cmd[[autocmd FileType c,cpp call vista#sidebar#Toggle()]]

-- python
vim.cmd[[autocmd FileType python call vista#sidebar#Toggle()]]

