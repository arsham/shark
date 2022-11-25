local tree_cb = require("nvim-tree.config").nvim_tree_callback
local nvim_tree = require("nvim-tree")
nvim_tree.setup({
  disable_netrw = false,
  hijack_netrw = false,
  hijack_cursor = true,
  diagnostics = { --{{{
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  }, --}}}

  filters = { --{{{
    dotfiles = true,
    exclude = { ".github", "tmp" },
  }, --}}}

  git = { --{{{
    enable = true,
    ignore = false,
    timeout = 500,
  }, --}}}

  view = { --{{{
    mappings = {
      custom_only = false,
      list = {
        { key = "h", cb = tree_cb("close_node") },
      },
    },
  }, --}}}

  actions = { --{{{
    open_file = {
      quit_on_open = true,
    },
  }, --}}}

  renderer = { --{{{
    highlight_git = true,
    icons = {
      glyphs = {
        git = { --{{{
          deleted = "",
          ignored = "◌",
          renamed = "➜",
          staged = "✓",
          unmerged = "",
          unstaged = "",
          untracked = "★",
        }, --}}}
        folder = { --{{{
          arrow_open = "▾",
          arrow_closed = "▸",
        }, --}}}
      },
    },
  }, --}}}
})

-- Mappings {{{
vim.keymap.set("n", "<leader>kk", nvim_tree.toggle, { silent = true, desc = "toggle tree view" })
vim.keymap.set("n", "<leader>kf", function()
  nvim_tree.find_file(true)
end, { silent = true, desc = "find file in tree view" })
--}}}

vim.api.nvim_create_autocmd("BufEnter", { --{{{
  nested = true,
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
      vim.api.nvim_command(":silent q")
    end
  end,
}) --}}}

-- vim: fdm=marker fdl=0
