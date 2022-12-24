local opt = { buffer = true, desc = "toggle lsp_lines" }
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.keymap.set("", "<localleader>l", function()
      local new_value = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({
        virtual_lines = new_value,
      })
    end, opt)
  end,
})

return {
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    local lsp_lines = require("lsp_lines")
    lsp_lines.setup()
    lsp_lines.toggle()
  end,
  event = { "LspAttach" },
}
