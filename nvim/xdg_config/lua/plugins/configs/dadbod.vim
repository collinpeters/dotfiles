xnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExeLine) db#op_exec() . '_'

xmap <leader>se <Plug>(DBExe)
nmap <leader>se <Plug>(DBExe)
omap <leader>se <Plug>(DBExe)
"nmap <leader>dbb <Plug>(DBExeLine)
