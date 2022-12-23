return {
  "arsham/fzfmania.nvim",
  dependencies = {
    {
      "junegunn/fzf.vim",
      dependencies = "junegunn/fzf",
    },
    "nvim-lua/plenary.nvim",
    "arsham/arshlib.nvim",
    "arsham/listish.nvim",
    {
      "ibhagwan/fzf-lua",
      dependencies = { "kyazdani42/nvim-web-devicons" },
    },
  },

  config = function()
    table.insert(vim.opt.rtp, "~/.fzf")

    local config = {
      mappings = {
        fzf_builtin = "<leader>tt",
      },
    }
    if require("util").full_start() then
      config.frontend = "fzf-lua"
    end

    require("fzfmania").config(config)

    local command = require("arshlib.quick").command
    command("Dotfiles", "call fzf#vim#files('~/dotfiles/', <bang>0)", { bang = true })

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
  event = { "VeryLazy" },
}

-- vim: foldmethod=marker foldlevel=0
