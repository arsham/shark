if ! exists(':TSConfigInfo')
    finish
endif

lua <<EOF
local treesitter_configs = require('nvim-treesitter.configs')

treesitter_configs.setup {
  ensure_installed = "maintained",
  indent = {enable = true},
  fold = {enable = true},
  highlight = {
    enable = true,
  },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
}

treesitter_configs.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner'
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]]"] = "@function.outer",
        ["]b"] = "@block.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
        ["]B"] = "@block.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[b"] = "@block.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[B"] = "@block.outer",
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["df"] = "@function.outer",
      },
    },
  },
}


EOF
