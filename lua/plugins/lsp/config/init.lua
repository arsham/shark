local function silent_reload() -- {{{
  -- If nvim is started with a file, because this is lazy loaded the server
  -- would not attach. We force read the file to kick-start the server. If all
  -- predicates are negative, then we can safely reload.
  local predicates = {
    function()
      return vim.bo.filetype == ""
    end,
    function()
      local filename = vim.api.nvim_buf_get_name(0)
      return filename:find("fugitive:///")
    end,
    function()
      return vim.bo.filetype == "man"
    end,
  }
  for _, fn in ipairs(predicates) do
    if fn() then
      return
    end
  end
  vim.cmd("silent! e")
end
silent_reload() -- }}}

local popup_window = {
  stylize_markdown = true,
  syntax = "lsp_markdown",
  border = require("config.icons").border_fn("FloatBorder"),
  width = 100,
  height = 10,
  max_height = 20,
  max_width = 140,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, popup_window)
vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, popup_window)

-- Disable LSP diagnostics in diff mode
vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "diff",
  group = vim.api.nvim_create_augroup("DiagnosticDisableInDiff", {}),
  callback = function(info)
    if vim.v.option_new == "1" then
      vim.diagnostic.enable(false, { bufnr = info.buf })
      vim.b._lsp_diagnostics_temp_disabled = true
    elseif
      vim.fn.match(vim.fn.mode(), "[iRsS\x13].*") == -1
      and vim.b._lsp_diagnostics_temp_disabled
    then
      vim.diagnostic.enable(info.buf)
      vim.b._lsp_diagnostics_temp_disabled = nil
    end
  end,
  desc = "Disable LSP diagnostics in diff mode.",
})

require("neodev").setup({})

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
