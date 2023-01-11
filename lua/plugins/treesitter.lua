local function config()
  local parsers = require("nvim-treesitter.parsers")
  local parser_config = parsers.get_parser_configs()

  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.indentexpr = "nvim_treesitter#indent()"

  parser_config.gotmpl = { --{{{
    install_info = {
      url = "https://github.com/ngalaiko/tree-sitter-go-template",
      files = { "src/parser.c" },
    },
    filetype = "gotmpl",
    used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
  } --}}}

  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",

    fold = { enable = true },
    highlight = { --{{{
      enable = true,
      use_languagetree = false,
      disable = function(_, bufnr)
        return vim.api.nvim_buf_line_count(bufnr or 0) > vim.g.treesitter_highlight_maxlines
      end,
      custom_captures = {
        ["function.call"] = "TSFunction",
        ["function.bracket"] = "Type",
        ["namespace.type"] = "Namespace",
      },
    }, --}}}

    context_commentstring = { --{{{
      enable = true,
      enable_autocmd = false,
      config = {
        c = "// %s",
        go = "// %s",
        sql = "-- %s",
        lua = "-- %s",
        vim = '" %s',
      },
    }, --}}}

    textobjects = { --{{{
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["am"] = "@call.outer",
          ["im"] = "@call.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["as"] = "@statement.outer",
        },
      }, --}}}

      move = { --{{{
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]b"] = "@block.outer",
          ["]gc"] = "@comment.outer",
          ["]a"] = "@parameter.inner",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]B"] = "@block.outer",
          ["]A"] = "@parameter.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[b"] = "@block.outer",
          ["[gc"] = "@comment.outer",
          ["[a"] = "@parameter.inner",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[B"] = "@block.outer",
          ["[A"] = "@parameter.outer",
        },
      }, --}}}

      swap = { --{{{
        enable = true,
        swap_next = {
          ["<leader>.f"] = "@function.outer",
          ["<leader>.e"] = "@element",
        },
        swap_previous = {
          ["<leader>,f"] = "@function.outer",
          ["<leader>,e"] = "@element",
        },
      }, --}}}

      lsp_interop = { --{{{
        enable = true,
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
        },
      }, --}}}
    },

    playground = { --{{{
      enable = true,
      updatetime = 25,
      persist_queries = true,
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    }, --}}}

    refactor = { -- {{{
      highlight_definitions = {
        enable = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > vim.g.treesitter_refactor_maxlines
        end,
      },
    }, -- }}}

    autopairs = { enable = true },
    matchup = { enable = true },
  })
end

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
    {
      "nvim-treesitter/playground",
      build = ":TSInstall query",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      cond = require("util").full_start,
    },
    "JoosepAlviste/nvim-ts-context-commentstring",
    "andymass/vim-matchup",
  },
  build = ":TSUpdate",
  cmd = "TSUpdate",
  event = { "VeryLazy" },
  priority = 80,
  config = config,
}

-- vim: fdm=marker fdl=0
