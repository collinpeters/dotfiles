lua require('lsp.conf').setup()

autocmd BufNewFile,BufRead pom.xml set filetype=xml.maven

augroup lsp
	au!
	au FileType java lua require('lsp.conf').start_jdt()
  "disable for now, don't always want to start jdt when editing pom
	"au FileType xml.maven lua require('lsp.conf').start_jdt()

"  au FileType sh lua require('lsp.conf').add_client({'bash-language-server', 'start'}, {name = 'bash-ls'})

	" TODO
  " au FileType haskell lua require('me.lsp.conf').start_hie()
  " au FileType python lua require('me.lsp.conf').add_client({'pyls'})
  " au FileType html lua require('me.lsp.conf').add_client({'html-languageserver', '--stdio'}, {name='html-ls'})
  " au FileType go lua require('me.lsp.conf').gopls()
  " au FileType rust lua require('me.lsp.conf').add_client({'rls'}, {root={'Cargo.toml', '.git'}})
  " au FileType lua lua require('me.lsp.conf').start_lua_ls()
  " au FileType json lua require('me.lsp.conf').add_client({'json-languageserver', '--stdio'}, {name='json-ls'})
  " au FileType css lua require('me.lsp.conf').add_client({'css-languageserver', '--stdio'}, {name='css-ls'})
  " au FileType cs lua require('me.lsp.conf').start_omnisharp()
  " au FileType c lua require('me.lsp.conf').add_client({'clangd'})
  " au FileType tex lua require('me.lsp.conf').add_client({'texlab'})
  " au FileType yaml lua require('me.lsp.conf').start_yaml_ls()
  " au FileType * lua require('me').init_hl()
  " au FileType * lua require('me').enable_lint()
augroup end

imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
