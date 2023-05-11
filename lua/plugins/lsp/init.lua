local function config()
  local path = require("mason-core.path")
  require("mason").setup({
    install_root_dir = path.concat({ vim.fn.stdpath("cache"), "mason" }),
    max_concurrent_installers = 4,
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "dockerls",
      "jedi_language_server",
      "marksman",
      "rust_analyzer@nightly",
      "sqls",
      "tsserver",
      "vimls",
    },
    automatic_installation = true,
  })

  require("mason-tool-installer").setup({
    ensure_installed = {
      "autopep8",
      "buf",
      "cbfmt",
      "delve",
      "fixjson",
      "golangci-lint",
      "hadolint",
      "prettier",
      "rustfmt",
      "selene",
      "shellcheck",
      "shellharden",
      "shfmt",
      "stylua",
    },

    auto_update = false,
  })

  vim.defer_fn(function()
    require("mason-tool-installer").run_on_start()
  end, 2000)

  -- Now we can setup lsp, not before!
  require("plugins.lsp.lsp_config")

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

return {
  "williamboman/mason.nvim",
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "ibhagwan/fzf-lua",
        "jose-elias-alvarez/null-ls.nvim",
      },
    },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
  },
  event = { "VeryLazy" },
  cond = require("util").full_start_with_lsp,
  config = config,
}
