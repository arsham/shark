(var_spec) @scope

(field_declaration
  name: (field_identifier) @definition.field)

(method_declaration
  name: (field_identifier) @method.name
  parameters: (parameter_list) @method.parameter_list) @interface.method.declaration

(type_declaration
  (type_spec
    name: (type_identifier) @name
    type: [(struct_type) (interface_type)] @type)) @start

;; vim: fo-=t
