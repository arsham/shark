return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "luarocks.nvim",
  },
  ft = { "http" },

  opts = {
    skip_ssl_verification = true,
    encode_url = true,
    highlight = {
      enable = true,
      timeout = 150,
    },
    result = {
      split = {
        horizontal = false,
        in_place = false,
      },
      behavior = {
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end,
        },
      },
    },
    env_file = ".env",
    custom_dynamic_variables = {},
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
        vim.keymap.set("n", "<localleader>rr", "<cmd>Rest run<CR>", o("Run the request under cursor"))
        vim.keymap.set("n", "<localleader>rp", "<Plug>RestNvimPreview", o("Preview the request cURL command"))
        vim.keymap.set("n", "<localleader>R", "<cmd>Rest last<CR>", o("Run the last request"))
      end,
    })
  end,

  enabled = require("config.util").is_enabled("rest-nvim/rest.nvim"),
}
