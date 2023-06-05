local colorizer_ft = { "css", "scss", "sass", "html", "lua", "markdown", "norg" }
return {
  "NvChad/nvim-colorizer.lua",
  ft = colorizer_ft,
  opts = {
    filetypes = colorizer_ft,
  },
  enabled = require("config.util").is_enabled("NvChad/nvim-colorizer.lua"),
}
