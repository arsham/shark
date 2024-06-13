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
    indent = {
      enable = true,
      disable = function(_, bufnr)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size < constants.treesitter_indent_max_filesize then
          return false
        end
        return true
      end,
    },
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size < constants.treesitter_highlight_max_filesize then
          return false
        end
        return vim.api.nvim_buf_line_count(bufnr or 0) > constants.treesitter_highlight_maxlines
      end,
      custom_captures = {
        ["function.call"] = "TSFunction",
        ["function.bracket"] = "Type",
        ["namespace.type"] = "Namespace",
      },
    },
  },

  config = function(_, opts)
    local parsers = require("nvim-treesitter.parsers")
    local parser_config = parsers.get_parser_configs()

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    parser_config.gotmpl = { --{{{
      install_info = {
        url = "https://github.com/ngalaiko/tree-sitter-go-template",
        files = { "src/parser.c" },
      },
      filetype = "gotmpl",
      used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
    } --}}}

    require("nvim-treesitter.configs").setup(opts)

    local ok, ts_repeat_move = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    if not ok then
      return
    end

    -- Repeat movement with ; and ,
    vim.keymap.set({ "n", "x" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
  enabled = require("config.util").is_enabled("nvim-treesitter/nvim-treesitter"),
}

-- vim: fdm=marker fdl=0
