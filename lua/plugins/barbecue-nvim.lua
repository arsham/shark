return {
  "utilyre/barbecue.nvim",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  config = function()
    require("barbecue").setup({
      create_autocmd = false,
      attach_navic = false, -- in some cases the data is nil and causes errors
      symbols = {
        separator = "▶",
      },
      kinds = require("config.icons").kinds,
    })

    vim.api.nvim_create_autocmd({
      "WinResized",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
    }, {
      group = require("config.util").augroup("barbecue.updater"),
      callback = function()
        require("barbecue.ui").update()
      end,
    })

    local navic = require("nvim-navic")
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "Navic Attacher",
      group = require("config.util").augroup("barbecue.navic"),
      callback = function(a)
        if not a.data then
          return
        end
        local client = vim.lsp.get_client_by_id(a.data.client_id)
        if client.server_capabilities["documentSymbolProvider"] then
          navic.attach(client, a.buf)
        end
      end,
    })
  end,
  event = { "LspAttach" },
  cond = require("config.util").should_start("utilyre/barbecue.nvim"),
  enabled = require("config.util").is_enabled("utilyre/barbecue.nvim"),
}
