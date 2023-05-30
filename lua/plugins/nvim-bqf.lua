return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    "junegunn/fzf",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "qf" },
  opts = {
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
  },
  cond = require("config.util").should_start("kevinhwang91/nvim-bqf"),
  enabled = require("config.util").is_enabled("kevinhwang91/nvim-bqf"),
}
