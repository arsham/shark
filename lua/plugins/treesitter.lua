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
          ["af"] = { query = "@function.outer", desc = "Select around a function" },
          ["if"] = { query = "@function.inner", desc = "Select inside a function" },
          ["am"] = { query = "@call.outer", desc = "Select around a method" },
          ["im"] = { query = "@call.inner", desc = "Select inside a method" },
          ["ab"] = { query = "@block.outer", desc = "Select around a block" },
          ["ib"] = { query = "@block.inner", desc = "Select inside a block" },
          ["aa"] = { query = "@parameter.outer", desc = "Select around a parameter" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inside a parameter" },
          ["as"] = { query = "@statement.outer", desc = "Select around a statement" },
        },
      }, --}}}

      move = { --{{{
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Go to start of the next function" },
          ["]b"] = { query = "@block.outer", desc = "Go to start of the next block" },
          ["]gc"] = { query = "@comment.outer", desc = "Go to start of the next comment" },
          ["]a"] = { query = "@parameter.inner", desc = "Go to start of the next parameter" },
          ["]o"] = { query = "@loop.*", desc = "Go to the next loop" },
          ["]s"] = {
            query = "@scope",
            query_group = "locals",
            desc = "Go to the next scope",
          },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "Go to end of the next function" },
          ["]B"] = { query = "@block.outer", desc = "Go to end of the next block" },
          ["]A"] = { query = "@parameter.outer", desc = "Go to end of the next parameter" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Go to start of the previous function" },
          ["[b"] = { query = "@block.outer", desc = "Go to start of the previous block" },
          ["[gc"] = { query = "@comment.outer", desc = "Go to start of the previous comment" },
          ["[a"] = { query = "@parameter.inner", desc = "Go to start of the previous parameter" },
          ["[o"] = { query = "@loop.*", desc = "Go to the previous loop" },
          ["[s"] = {
            query = "@scope",
            query_group = "locals",
            desc = "Go to the previous scope",
          },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "Go to end of the previous function" },
          ["[B"] = { query = "@block.outer", desc = "Go to end of the previous block" },
          ["[A"] = { query = "@parameter.outer", desc = "Go to end of the previous parameter" },
        },
      }, --}}}

      swap = { --{{{
        enable = true,
        swap_next = {
          ["<leader>.f"] = {
            query = "@function.outer",
            desc = "Swap around with the next function",
          },
          ["<leader>.e"] = { query = "@element", desc = "Swap with the next element" },
        },
        swap_previous = {
          ["<leader>,f"] = {
            query = "@function.outer",
            desc = "Swap around with the previous function",
          },
          ["<leader>,e"] = { query = "@element", desc = "Swap with the previous element" },
        },
      }, --}}}

      lsp_interop = { --{{{
        enable = true,
        peek_definition_code = {
          ["<leader>df"] = { query = "@function.outer", desc = "Peek function definition" },
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
  event = { "VeryLazy" },
  priority = 80,
  config = config,
}

-- vim: fdm=marker fdl=0
