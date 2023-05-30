return {
  "arsham/arshamiser.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Defer setting the colorscheme until the UI loads.
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = function()
        vim.cmd.colorscheme("arshamiser_light")
        require("arshamiser.feliniser")
        vim.api.nvim_set_option("tabline", [[%{%v:lua.require("arshamiser.tabline").draw()%}]])
      end,
    })
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "freddiehaddad/feline.nvim",
      branch = "main",
      dependencies = "nvim-tree/nvim-web-devicons",
    },
  },
}
