return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "http" },

  opts = {
    result_split_horizontal = false,
    result_split_in_place = false,
    skip_ssl_verification = true,
    encode_url = true,
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      show_url = true,
      show_http_info = true,
      show_headers = true,
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
        end,
      },
    },
    jump_to_request = false,
    env_file = ".env",
    custom_dynamic_variables = {},
    yank_dry_run = true,
  },

  config = function(_, opts)
    require("rest-nvim").setup(opts)
    local function o(desc)
      return { desc = desc, buffer = true, silent = true }
    end
    vim.api.nvim_create_autocmd("FileType", {
      group = require("config.util").augroup("rest_nvim"),
      pattern = "http",
      -- stylua: ignore
      callback = function()
        vim.keymap.set("n", "<localleader>rr", "<Plug>RestNvim", o("Run the request under cursor"))
        vim.keymap.set("n", "<localleader>rp", "<Plug>RestNvimPreview", o("Preview the request cURL command"))
        vim.keymap.set("n", "<localleader>R", "<Plug>RestNvimLast", o("Run the last request"))
      end,
    })
  end,

  cond = require("config.util").should_start("rest-nvim/rest.nvim"),
  enabled = require("config.util").is_enabled("rest-nvim/rest.nvim"),
}
