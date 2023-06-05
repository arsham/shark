return {
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  name = "lsp_lines.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  event = { "LspAttach" },
  config = function()
    local lsp_lines = require("lsp_lines")
    lsp_lines.setup()
    lsp_lines.toggle()

    local default_virtual_text = vim.diagnostic.config().virtual_text or {}
    local opt = { buffer = true, desc = "toggle lsp_lines" }
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        vim.keymap.set("", "<localleader>l", function()
          local new_value = not vim.diagnostic.config().virtual_lines
          local virtual_text = default_virtual_text
          if new_value then
            virtual_text = false
          end
          vim.diagnostic.config({
            virtual_lines = new_value,
            virtual_text = virtual_text,
          })
        end, opt)
      end,
    })
  end,
  enabled = require("config.util").is_enabled("lsp_lines.nvim"),
}
