return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    "junegunn/fzf",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("bqf").setup({
      auto_resize_height = true,
      preview = {
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          -- skip file size greater than 100k or is fugitive buffer
          if fsize > 100 * 1024 or bufname:match("^fugitive://") then
            ret = false
          end
          return ret
        end,
      },
    })
  end,
  ft = { "qf" },
  cond = require("util").full_start,
}
