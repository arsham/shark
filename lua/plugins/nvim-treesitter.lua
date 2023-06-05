local constants = require("config.constants")

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-refactor",
    {
      "David-Kunz/treesitter-unit",
      -- stylua: ignore
      keys = {
        { mode = "x", "iu", ':lua require"treesitter-unit".select()<CR>',          { desc = "select in unit" } },
        { mode = "x", "au", ':lua require"treesitter-unit".select(true)<CR>',      { desc = "select around unit" } },
        { mode = "o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>',     { desc = "select in unit" } },
        { mode = "o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>', { desc = "select around unit" } },
      },
    },
    "JoosepAlviste/nvim-ts-context-commentstring",
    "andymass/vim-matchup",
  },
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  priority = 80,
  opts = {
    ensure_installed = "all",

    fold = { enable = true },
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size < constants.treesitter_highlight_max_filesize then
          return false
        end
        return vim.api.nvim_buf_line_count(bufnr or 0) > constants.treesitter_highlight_maxlines
      end,
    },
  },

  config = function(_, opts)
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.indentexpr = "nvim_treesitter#indent()"

    require("nvim-treesitter.configs").setup(opts)
  end,
  enabled = require("config.util").is_enabled("nvim-treesitter/nvim-treesitter"),
}

-- vim: fdm=marker fdl=0
