(
 (
  (
   [
    (interpreted_string_literal)
    (raw_string_literal)] @sql
      (#match? @sql "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values).*(WHERE|where|GROUP BY|group by)?"))))
