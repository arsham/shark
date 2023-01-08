return {
  "ziontee113/color-picker.nvim",
  keys = {
    {
      mode = "n",
      "<leader>cp",
      "<cmd>PickColor<cr>",
      noremap = true,
      silent = true,
      desc = "Invoke the colour picker",
    },
  },
  opts = {
    ["icons"] = { "ﱢ", "" },
  },
}
