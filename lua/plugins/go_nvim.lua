return {
  "ray-x/go.nvim",
  config = function()
    require("go").setup({
      gofmt = "gofumpt",
      lsp_codelens = false,
      lsp_diag_hdlr = true,
      textobjects = false,
      run_in_floaterm = false,
    })
  end,
  ft = { "go" },
  enabled = require("util").full_start_with_lsp,
}
