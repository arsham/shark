return {
  "arsham/archer.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  config = function()
    require("archer").config({})
  end,
  event = { "VeryLazy" },
}
