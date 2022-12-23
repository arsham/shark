return {
  "ziontee113/color-picker.nvim",
  config = function()
    vim.keymap.set("n", "<leader>cp", "<cmd>PickColor<cr>", { noremap = true, silent = true })

    require("color-picker").setup({
      ["icons"] = { "ﱢ", "" },
    })
  end,
  keys = { "<leader>cp" },
}
