local util = require('util')

return {
  setup = function()
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_git_hl       = 1
    vim.g.nvim_tree_refresh_wait = 500

    vim.g.nvim_tree_icons = {
      lsp = {
        hint    = "💡",
        info    = "💬",
        warning = "💩",
        error   = "🔥",
      },
      git = {
        deleted   = "",
        ignored   = "◌",
        renamed   = "➜",
        staged    = "✓",
        unmerged  = "",
        unstaged  = "",
        untracked = "★",
      },
      folder = {
        arrow_open   = "▾",
        arrow_closed = "▸",
      },
    }
  end,

  config = function()
    require('nvim-tree').setup {
      disable_netrw = false,
      hijack_netrw  = false,
      auto_close    = true,
      diagnostics   = {
        enable = true,
        icons = {
          hint    = "",
          info    = "",
          warning = "",
          error   = "",
        }
      },
      filters = {
        dotfiles = false,
        custom   = { '.git', 'node_modules', '.cache' },
      },
      git = {
        enable  = true,
        ignore  = false,
        timeout = 500,
      },
    }

    util.nnoremap{'<leader>kk', function()
      require'nvim-tree'.toggle()
    end, silent=true, desc='Toggle tree view'}
    util.nnoremap{'<leader>kf', function()
      require'nvim-tree'.find_file(true)
    end, silent=true, desc='Find file in tree view'}
    util.nnoremap{'<leader><leader>', function()
      require'nvim-tree'.toggle()
    end, silent=true, desc='Toggle tree view'}
  end
}
