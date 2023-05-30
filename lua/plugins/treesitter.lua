local function config()
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.indentexpr = "nvim_treesitter#indent()"

  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",

    fold = { enable = true },
    highlight = { --{{{
      enable = true,
    }, --}}}
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  priority = 80,
  config = config,
}

-- vim: fdm=marker fdl=0
