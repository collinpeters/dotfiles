" " define text object for entire file
" onoremap f :<c-u>normal! mzggVG<cr>`z
"
" nmap <expr> dy db#op_exec()
" " current line
" nmap dyy dy_
" " entire file
" nmap dya dyf
" nmap <expr> <leader>sea dyf
" " visual mode
" "xmap <expr> D db#op_exec()
" xmap <expr> <leader>se db#op_exec()

xnoremap <expr> <Plug>(DBExe)     db#op_exec()
"nnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExeLine) db#op_exec() . '_'
nnoremap <expr> <Plug>(DBExeAll)  db#op_exec() . ':<c-u>normal! mzggVG<cr>`z'

xmap <leader>se  <Plug>(DBExe)
"nmap <leader>se  <Plug>(DBExe)
nmap <leader>sel <Plug>(DBExeLine)
nmap <leader>sea <Plug>(DBExeAll)


func! DBDescribeTable(...)
	if !a:0
		let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
		return 'g@'
	endif
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@

	if a:1 == 'char'	" Invoked from Visual mode, use gv command.
		silent exe 'normal! gvy'
	elseif a:1 == 'line'
		silent exe "normal! '[V']y"
	else
		silent exe 'normal! `[v`]y'
	endif

	execute "DB \\d+ " . @@

	let &selection = sel_save
	let @@ = reg_save
endfunc

xnoremap <expr> <Plug>(DBDescribe)     DBDescribeTable()
xmap <leader>sd <Plug>(DBDescribe)
