return {
  "arsham/arshamiser.nvim",
  dev = true,
  config = function()
    vim.opt.background = "dark"
    vim.opt.guifont = "MesloLGS NF:h10"
    vim.opt.termguicolors = true

    -- Defer setting the colorscheme until the UI loads.
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = function()
        vim.cmd.colorscheme("arshamiser_light")
        require("arshamiser.feliniser")
        -- selene: allow(global_usage)
        _G.custom_foldtext = require("arshamiser.folding").foldtext
        vim.opt.foldtext = "v:lua.custom_foldtext()"

        vim.api.nvim_set_option("tabline", [[%{%v:lua.require("arshamiser.tabline").draw()%}]])
      end,
    })
  end,
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    {
      "feline-nvim/feline.nvim",
      dependencies = "kyazdani42/nvim-web-devicons",
    },
  },
}
