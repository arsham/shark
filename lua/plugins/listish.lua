return {
  "arsham/listish.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  event = { "VeryLazy" },
  config = function()
    require("listish").config({})
  end,
}
