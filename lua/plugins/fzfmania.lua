return {
  "arsham/fzfmania.nvim",
  name = "fzfmania.nvim",
  dependencies = {
    {
      "junegunn/fzf.vim",
      dependencies = "junegunn/fzf",
    },
    "nvim-lua/plenary.nvim",
    "arshlib.nvim",
    "listish.nvim",
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
  },

  config = function()
    vim.opt.rtp:append("~/.fzf")

    local config = {
      mappings = {
        fzf_builtin = false,
      },
      frontend = "fzf-lua",
    }

    require("fzfmania").config(config)
    vim.cmd.FzfLua("register_ui_select")
  end,
  event = { "VeryLazy" },
}

-- vim: fdm=marker fdl=0
