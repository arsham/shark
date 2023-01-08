local colorizer_ft = { "css", "scss", "sass", "html", "lua", "markdown", "norg" }
return {
  "NvChad/nvim-colorizer.lua",
  ft = colorizer_ft,
  cond = require("util").full_start,
  opts = {
    filetypes = colorizer_ft,
  },
}
