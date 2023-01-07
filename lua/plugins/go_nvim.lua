return {
  "ray-x/go.nvim",
  ft = { "go" },
  cond = require("util").full_start_with_lsp,
  config = {
    gofmt = "gofumpt",
    lsp_codelens = false,
    lsp_diag_hdlr = true,
    textobjects = false,
    run_in_floaterm = false,
  },
}
