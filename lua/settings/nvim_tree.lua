local util = require("util")

return {
  setup = function()
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_git_hl = 1

    vim.g.nvim_tree_icons = {
      lsp = {
        hint = "💡",
        info = "💬",
        warning = "💩",
        error = "🔥",
      },
      git = {
        deleted = "",
        ignored = "◌",
        renamed = "➜",
        staged = "✓",
        unmerged = "",
        unstaged = "",
        untracked = "★",
      },
      folder = {
        arrow_open = "▾",
        arrow_closed = "▸",
      },
    }
  end,

  config = function()
    local tree_cb = require("nvim-tree.config").nvim_tree_callback
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup({
      disable_netrw = false,
      hijack_netrw = false,
      hijack_cursor = true,
      auto_close = true,
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      filters = {
        dotfiles = false,
        custom = { ".git", "node_modules", ".cache" },
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
      view = {
        mappings = {
          custom_only = false,
          list = {
            { key = "h", cb = tree_cb("close_node") },
          },
        },
      },
    })

    util.nnoremap({ "<leader>kk", nvim_tree.toggle, silent = true, desc = "Toggle tree view" })
    util.nnoremap({
      "<leader>kf",
      function()
        nvim_tree.find_file(true)
      end,
      silent = true,
      desc = "Find file in tree view",
    })
    util.nnoremap({ "<leader><leader>", nvim_tree.toggle, silent = true, desc = "Toggle tree view" })
  end,
}
