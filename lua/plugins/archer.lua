return {
  "arsham/archer.nvim",
  dependencies = { "arsham/arshlib.nvim" },
  event = { "VeryLazy" },
  opts = {
    textobj = {
      last_changed = { "ix", "ax" },
      context = { "iC", "aC" },
    },
  },
}
