require("nvim-treesitter.configs").setup({
  refactor = {
    highlight_definitions = {
      enable = true,
      disable = function(_, bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > vim.g.treesitter_refactor_maxlines
      end,
    },
  },
})
