return {
  "arsham/archer.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    textobj = {
      last_changed = { "ix", "ax" },
      context = { "iC", "aC" },
    },
  },
}
