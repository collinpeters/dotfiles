" Emulate F3 in Eclipse
nnoremap <silent> <F3> :JavaSearchContext<CR>

" <leader>i to do an import of the class under the cursor
nnoremap <silent> <buffer> <leader>i :JavaImport<cr>

" Import the class under the cursor with <leader>i (:h mapleader):
nnoremap <silent> <buffer> <leader>i :JavaImport<cr>

" Search for the javadocs of the element under the cursor with <leader>d.
nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<cr>

" Perform a context sensitive search of the element under the cursor with <enter>.
"nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
