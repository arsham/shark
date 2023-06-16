return {
  "jackMort/ChatGPT.nvim",
  config = function()
    require("chatgpt").setup()
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = {
    "ChatGPT",
    "ChatGPTActAs",
    "ChatGPTEditWithInstructions",
    "ChatGPTRun",
    "ChatGPTCompleteCode",
  },
}
