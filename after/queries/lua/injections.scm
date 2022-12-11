;; Lua Injections

;; Luap
(function_call
  name: (_) @_fname
  arguments: (arguments (_) (string content: _ @luap))
  (#lua-match? @_fname "%.match$"))

(function_call
  name: (_) @_fname
  arguments: (arguments (string content: _ @luap))
  (#lua-match? @_fname ":match$"))

(
 (function_call
   (identifier) @_exec_lua
   (arguments
     (string) @lua)
   )

 (#eq? @_exec_lua "exec_lua")
 (#lua-match? @lua "^%[%[")
 (#offset! @lua 0 2 0 -2)
 )

(
 (function_call
   (identifier) @_exec_lua
   (arguments
     (string) @lua)
   )

 (#eq? @_exec_lua "exec_lua")
 (#lua-match? @lua "^[\"']")
 (#offset! @lua 0 1 0 -1)
 )

;; Vimscript Injections

((function_call
   name: (_) @_vimcmd_identifier
   arguments: (arguments (string content: _ @vim)))
 (#any-of? @_vimcmd_identifier "cmd" "vim.cmd" "vim.api.nvim_command" "vim.api.nvim_exec"))

((function_call
   name: (_) @_vimcmd_identifier
   arguments: (arguments (string content: _ @query) .))
 (#eq? @_vimcmd_identifier "vim.treesitter.query.set_query"))

(comment) @comment
