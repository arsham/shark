return {
  {
    "arsham/arshamiser.nvim",
    name = "arshamiser.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Defer setting the colorscheme until the UI loads.
      vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
          vim.cmd.colorscheme("arshamiser_light")
          -- selene: allow(global_usage)
          _G.custom_foldtext = require("arshamiser.folding").foldtext
          vim.opt.foldtext = "v:lua.custom_foldtext()"
        end,
      })
    end,
    cond = require("config.util").should_start("arsham/arshamiser.nvim"),
    enabled = require("config.util").is_enabled("arsham/arshamiser.nvim"),
  },
  {
    "arsham/arshamiser.nvim",
    name = "feliniser.nvim",
    config = function()
      vim.schedule(function()
        require("arshamiser.feliniser")
        vim.api.nvim_set_option_value(
          "tabline",
          [[%{%v:lua.require("arshamiser.tabline").draw()%}]],
          {}
        )
      end)
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arshamiser.nvim",
      {
        "freddiehaddad/feline.nvim",
        branch = "main",
        dependencies = "nvim-tree/nvim-web-devicons",
      },
    },
    event = { "VeryLazy" },
    cond = require("config.util").should_start("arsham/feliniser.nvim"),
    enabled = require("config.util").is_enabled("arsham/feliniser.nvim"),
  },
}
