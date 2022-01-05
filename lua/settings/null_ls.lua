local util = require("util")
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua.with({
      extra_args = { "--indent-type=Spaces", "--indent-width=2", "--column-width=100" },
    }),
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.selene,
  },
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      util.autocmd({
        "BufWritePre",
        run = function()
          vim.lsp.buf.formatting_sync()
        end,
        buffer = true,
      })
    end
    if client.resolved_capabilities.document_range_formatting then
      util.buffer_command("Format", function(args)
        require("settings.lsp.util").format_command(
          args.range ~= 0,
          args.line1,
          args.line2,
          args.bang
        )
      end, { range = true })
      util.vnoremap({ "gq", ":Format<CR>", buffer = true, silent = true, desc = "format range" })
      vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
    end
  end,
})
