; extends

(short_var_declaration
    left: (expression_list
            (identifier))
    right: (expression_list
             (raw_string_literal) @injection.content (#offset! @injection.content 0 1 0 -1))
    (#set! injection.language "sql"))

(var_declaration
  (var_spec
    name: (identifier)
    value: (expression_list
             (raw_string_literal) @injection.content (#offset! @injection.content 0 1 0 -1)))
    (#set! injection.language "sql"))

(const_declaration
  (const_spec
    name: (identifier)
    value: (expression_list
             (raw_string_literal) @injection.content (#offset! @injection.content 0 1 0 -1)))
    (#set! injection.language "sql"))

; json

((const_spec
  name: (identifier) @_const
  value: (expression_list (raw_string_literal) @json))
 (#lua-match? @_const ".*[J|j]son.*"))

; jsonStr := `{"foo": "bar"}`

((short_var_declaration
    left: (expression_list
            (identifier) @_var)
    right: (expression_list
             (raw_string_literal) @json))
  (#lua-match? @_var ".*[J|j]son.*")
  (#offset! @json 0 1 0 -1))

; nvim 0.10

(const_spec
  name: ((identifier) @_const(#lua-match? @_const ".*[J|j]son.*"))
  value: (expression_list (raw_string_literal) @injection.content
   (#set! injection.language "json")))

(short_var_declaration
    left: (expression_list (identifier) @_var (#lua-match? @_var ".*[J|j]son.*"))
    right: (expression_list (raw_string_literal) @injection.content)
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "json"))

(var_spec
  name: ((identifier) @_const(#lua-match? @_const ".*[J|j]son.*"))
  value: (expression_list (raw_string_literal) @injection.content
   (#set! injection.language "json")))


;; vim: fo-=t
