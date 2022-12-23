local colorizer_ft = { "css", "scss", "sass", "html", "lua", "markdown", "norg" }
return {
  "NvChad/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      filetypes = colorizer_ft,
    })
  end,
  ft = colorizer_ft,
  enabled = require("util").full_start,
}
