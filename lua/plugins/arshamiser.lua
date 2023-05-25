return {
  "arsham/arshamiser.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Defer setting the colorscheme until the UI loads.
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = function()
        vim.cmd.colorscheme("arshamiser_light")
      end,
    })
  end,
}
