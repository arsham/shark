return {
  "arsham/fzfmania.nvim",
  name = "fzfmania.nvim",
  dependencies = {
    {
      "junegunn/fzf.vim",
      dependencies = {
        "junegunn/fzf",
        enabled = require("config.util").is_enabled("junegunn/fzf"),
      },
      enabled = require("config.util").is_enabled("junegunn/fzf.vim"),
    },
    "nvim-lua/plenary.nvim",
    "arshlib.nvim",
    "listish.nvim",
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      enabled = require("config.util").is_enabled("ibhagwan/fzf-lua"),
    },
  },

  config = function()
    vim.opt.rtp:append("~/.fzf")

    local config = {
      mappings = {
        fzf_builtin = false,
      },
    }

    if require("config.util").should_start("ibhagwan/fzf-lua") then
      config.frontend = "fzf-lua"
    end

    require("fzfmania").config(config)

    vim.keymap.set("n", "<leader>fl", function()
      vim.ui.input({
        prompt = "Term: ",
      }, function(term)
        if term then
          vim.schedule(function()
            local preview = vim.fn["fzf#vim#with_preview"]()
            vim.fn["fzf#vim#locate"](term, preview)
          end)
        end
      end)
    end, { silent = true, desc = "run locate" })

    vim.cmd.FzfLua("register_ui_select")
  end,
  keys = {
    "<leader>fh",
    "<leader>ff",
    "<leader>fF",
    "<leader>fa",
    "<leader>fA",
    "<leader>rg",
    "<leader>rG",
    "<leader>ra",
    "<leader>rA",
    "<C-p>",
    "<M-p>",
    "<C-b>",
    "<M-b>",
    "<C-_>",
  },
  event = { "InsertEnter" }, -- various actions happen here.
  enabled = require("config.util").is_enabled("arsham/fzfmania.nvim"),
}

-- vim: fdm=marker fdl=0
