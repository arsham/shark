local function exchange()
  return require("substitute.exchange")
end

return {
  "gbprod/substitute.nvim",
  -- stylua: ignore
  keys = {
    { mode = "n", "cx",  function() exchange().operator() end, { noremap = true, desc = "exchange operator" }},
    { mode = "n", "cxx", function() exchange().line() end,     { noremap = true, desc = "exchange the line" }},
    { mode = "x", "X",   function() exchange().visual() end,   { noremap = true, desc = "exchange operator" }},
    { mode = "n", "cxc", function() exchange().cancel() end,   { noremap = true, desc = "cancel exchange" }},
  },
  config = true,
  enabled = require("config.util").is_enabled("gbprod/substitute.nvim"),
}
