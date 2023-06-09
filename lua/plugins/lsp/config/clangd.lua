return {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  on_attach = function(client, bufnr)
    if vim.fn.findfile("uncrustify.cfg", ".;") ~= "" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    require("plugins.lsp.on_attach").on_attach(client, bufnr)
  end,
}
