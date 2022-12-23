return {
  "sQVe/sort.nvim",
  config = function()
    require("sort").setup({
      delimiters = { ",", "|", ";", ":", "s", "t" },
    })
  end,
  cmd = { "Sort" },
}
