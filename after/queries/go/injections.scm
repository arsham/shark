;; extends

(short_var_declaration
    left: (expression_list
            (identifier))
    right: (expression_list
             (raw_string_literal) @sql (#offset! @sql 0 1 0 -1)))

(var_declaration
  (var_spec
    name: (identifier)
    value: (expression_list
             (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))))

(const_declaration
  (const_spec
    name: (identifier)
    value: (expression_list
             (raw_string_literal) @sql (#offset! @sql 0 1 0 -1))))

;; vim: fo-=t
