local cache = {}
local function get_name(filename) --{{{
  local ret = cache[filename]
  if ret ~= nil then
    return ret
  end

  ret = filename
  local extension = vim.fn.expand("%:e")
  local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
  if icon ~= nil then
    ret = " %#" .. name .. "#" .. icon .. " " .. filename
  end

  cache[filename] = ret
  return ret
end --}}}

local function config(_, opts)
  local navic = require("nvim-navic")

  navic.setup({
    icons = opts.icons,
    separator = opts.separator,
    highlight = true,
  })

  local bar = { --{{{
    provider = function()
      local filename = vim.fn.expand("%:t")
      local ret = get_name(filename)
      local extra = ""
      if navic.is_available() then
        extra = " " .. navic.get_location()
      end
      return ret .. extra
    end,
  } --}}}

  local components = {
    active = { { bar } },
    inactive = { { bar } },
  }

  vim.schedule(function()
    require("feline").winbar.setup({
      components = components,
      disable = opts.disable,
    })
  end)

  vim.api.nvim_create_autocmd("LspAttach", { -- {{{
    callback = function(args)
      if args.data == nil then
        return
      end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client.supports_method("textDocument/documentSymbol") then
        return
      end
      navic.attach(client, args.buf)
    end, -- }}}
  })
end

return {
  "SmiteshP/nvim-navic",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    icons = require("config.icons").navic,
    silence = true,
    separator = " %#CmpItemKindDefault#▶ %*",
    disable = {
      filetypes = { "neo-tree" },
    },
  },
  init = function()
    vim.g.navic_silence = true
  end,
  config = config,
  event = { "LspAttach" },
  enabled = require("config.util").is_enabled("SmitechP/nvim-navic"),
}

-- vim: fdm=marker fdl=0
