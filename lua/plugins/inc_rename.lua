return {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup({
      cmd_name = "Rename",
    })
  end,
  event = { "LspAttach" },
}
