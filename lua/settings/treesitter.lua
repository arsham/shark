local nvim = require("nvim")
local util = require("util")
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.indentexpr = "nvim_treesitter#indent()"

parser_config.sql = {
  install_info = {
    url = "https://github.com/DerekStride/tree-sitter-sql",
    files = { "src/parser.c" },
    branch = "main",
  },
}

parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",

  fold = { enable = true },
  highlight = {
    enable = true,
    use_languagetree = false,
    disable = { "json", "markdown" },
    custom_captures = {
      ["function.call"] = "TSFunction",
      ["function.bracket"] = "Type",
      ["namespace.type"] = "Namespace",
    },
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      c = "// %s",
      lua = "---%s",
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-n>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "<M-n>",
    },
  },

  textobjects = {
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
    },

    move = {
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
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>.f"] = "@function.outer",
        ["<leader>.e"] = "@element",
      },
      swap_previous = {
        ["<leader>,f"] = "@function.outer",
        ["<leader>,e"] = "@element",
      },
    },

    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
      },
    },
  },

  playground = {
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
  },

  autopairs = { enable = true },
})

util.augroup({
  "TREESITTER_LARGE_FILES",
  {
    {
      "BufRead",
      "*",
      docs = "large file enhancements",
      run = function()
        if vim.fn.expand("%:t") == "lsp.log" or vim.bo.filetype == "help" then
          return
        end
        local size = vim.fn.getfsize(vim.fn.expand("%"))
        if size > 64 * 1024 then
          vim.schedule(function()
            nvim.ex.TSBufDisable("refactor.highlight_definitions")
          end)
        end

        if size > 512 * 1024 then
          vim.schedule(function()
            nvim.ex.TSBufDisable("highlight")
          end)
        end
      end,
    },
  },
})
