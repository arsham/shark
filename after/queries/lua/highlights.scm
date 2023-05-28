;; Add _ to constant
((identifier) @constant
 (#lua-match? @constant "^[_A-Z][A-Z_0-9]*$"))

(
  (identifier) @function
  (#eq? @function "utils")
  (#set! conceal "")
)

(
  (dot_index_expression
    table: (identifier) @keyword
    (#eq? @keyword  "utils" )
  )
  (#set! conceal "U")
)

;; vim: fo-=t
