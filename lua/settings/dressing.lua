require("dressing").setup({
  input = {
    default_prompt = "➤ ",
    insert_only = false,
    winblend = 0,
    prefer_width = 100,
    min_width = 20,
  },

  select = {
    backend = { "fzf_lua", "fzf", "nui", "builtin" },
    fzf_lua = {
      winopts = {
        width = 0.5,
        height = 0.5,
      },
    },
    fzf = {
      window = {
        width = 0.5,
        height = 0.5,
      },
    },
  },
})
