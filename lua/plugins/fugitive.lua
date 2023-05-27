return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-git",
      "tpope/vim-rhubarb",
    },
    keys = {
      { mode = "n", "<leader>gg", ":Git<cr>", silent = true, desc = "Open fugitive" },
      { mode = "n", "<leader>gd", ":Git diff %<cr>", silent = true, desc = "View buffer's diff" },
    },
    lazy = false, -- otherwise starting directly into fugitive buffers would be empty.
    init = function()
      vim.g.fugitive_legacy_commands = 0

      vim.api.nvim_create_autocmd("FileType", {
        once = true,
        pattern = "fugitive",
        desc = "Fix fugitive startup empty buffer",
        callback = function()
          vim.schedule(function()
            vim.cmd("silent! e")
          end)
        end,
      })
    end,
    cond = require("config.util").should_start("tpope/vim-fugitive"),
    enabled = require("config.util").is_enabled("tpope/vim-fugitive"),
  },
  {
    "tpope/vim-git",
    cond = require("config.util").should_start("tpope/vim-git"),
    enabled = require("config.util").is_enabled("tpope/vim-git"),
  },
  {
    "tpope/vim-rhubarb",
    cond = require("config.util").should_start("tpope/vim-rhubarb"),
    enabled = require("config.util").is_enabled("tpope/vim-rhubarb"),
  },
}
