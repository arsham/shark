local constants = require("config.constants")

return {
  "nvim-treesitter/nvim-treesitter-refactor",
  lazy = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.refactor = {
        highlight_definitions = {
          enable = true,
          disable = function(_, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > constants.treesitter_refactor_maxlines
          end,
        },
      }
    end,
  },
  enabled = require("config.util").is_enabled("nvim-treesitter/nvim-treesitter-refactor"),
}
