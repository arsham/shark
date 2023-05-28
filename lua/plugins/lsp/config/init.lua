vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  stylize_markdown = true,
  syntax = "lsp_markdown",
  border = "single",
})

return function(opts)
  if opts.log_level == nil then
    opts.log_level = "error"
  end
  vim.lsp.set_log_level(opts.log_level)

  if vim.fn.has("nvim-0.10.0") == 0 then
    -- using a function is not supported in old versions.
    opts.diagnostics.virtual_text.prefix = "●"
  end
  vim.diagnostic.config(opts.diagnostics)
end

-- vim: fdm=marker fdl=0
