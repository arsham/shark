-- MixedCase/PascalCase:   gsm/gsp
-- camelCase:              gsc
-- snake_case:             gs_
-- UPPER_CASE:             gsu/gsU
-- Title Case:             gst
-- Sentence case:          gss
-- space case:             gs<space>
-- dash-case/kebab-case:   gs-/gsk
-- Title-Dash/Title-Kebab: gsK
-- dot.case:               gs.
return {
  "arthurxavierx/vim-caser",
  keys = { "gs" },
  enabled = require("config.util").is_enabled("arthurxavierx/vim-caser"),
}
