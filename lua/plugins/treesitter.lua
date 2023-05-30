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
          ["<leader>.a"] = { query = "@parameter.inner", desc = "Swap with the next parameter" },
        },
        swap_previous = {
          ["<leader>,f"] = {
            query = "@function.outer",
            desc = "Swap around with the previous function",
          },
          ["<leader>,e"] = { query = "@element", desc = "Swap with the previous element" },
          ["<leader>,a"] = { query = "@parameter.inner", desc = "Swap with the previous parameter" },
        },
      }, --}}}

      lsp_interop = { --{{{
        enable = true,
        peek_definition_code = {
          ["<leader>df"] = { query = "@function.outer", desc = "Peek function definition" },
        },
      }, --}}}
    },

    refactor = { -- {{{
      highlight_definitions = {
        enable = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > vim.g.treesitter_refactor_maxlines
        end,
      },
    }, -- }}}
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  priority = 80,
  config = config,
}

-- vim: fdm=marker fdl=0
