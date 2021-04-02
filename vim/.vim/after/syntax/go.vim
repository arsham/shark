" let saved_syntax = b:current_syntax
" unlet! b:current_syntax
"
" syntax include @SQL syntax/sql.vim
"
" syntax region sqlSnippet
"     \ start=/"\|`\zs\v(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|WITH)/
"     \ end=/\ze"\|`/
"     \ contains=@SQL
"
" let b:current_syntax = saved_syntax
" unlet! saved_syntax
