return {
  settings = {
    yaml = {
      format = { enable = true, singleQuote = true },
      validate = true,
      hover = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = require("plugins.lsp.config.schemas").yamlls,
    },
  },
}
