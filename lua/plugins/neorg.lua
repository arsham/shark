vim.api.nvim_create_autocmd("FileType", { -- {{{
  once = true,
  pattern = { "norg" },
  callback = function()
    vim.api.nvim_create_user_command("Journal", ":Neorg journal", {})
    vim.keymap.set("n", "<localleader>nr", ":Neorg return<CR>", { buffer = true })
    require("arshlib.quick").command("NG", function(args)
      require("neorg.modules.core.neorgcmd.module").public.function_callback(unpack(args.fargs))
    end, { nargs = "*", complete = "customlist,v:lua._neorgcmd_generate_completions" })
    vim.keymap.set(
      "n",
      "<localleader>nm",
      ":Neorg keybind norg core.looking-glass.magnify-code-block<CR>",
      { buffer = true }
    )

    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    parser_configs.norg_meta = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main",
      },
    }

    parser_configs.norg_table = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main",
      },
    }
  end,
}) -- }}}

return {
  "nvim-neorg/neorg",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "fzfmania.nvim",
  },
  build = ":Neorg sync-parsers",
  cmd = { "Neorg" },
  keys = {
    { mode = "n", "<leader>nh", ":Neorg workspace home<CR>" },
    { mode = "n", "<leader>nw", ":Neorg workspace <TAB>" },
    { mode = "n", "<leader>nj", ":Neorg journal<CR>" },
    { mode = "n", "<leader>ni", ":Neorg index<CR>" },
  },

  opts = {
    lazy_loading = false,
    load = {
      ["core.defaults"] = {},
      ["core.dirman"] = { --{{{
        config = {
          autochdir = false,
          autodetect = false,
          autochdetect = true,
          workspaces = {
            home = "~/Dropbox/Notes",
            work = "~/Dropbox/Notes/blokur",
          },
          default_workspace = "home",
        },
      }, --}}}
      ["core.concealer"] = { --{{{
        config = {
          markup_preset = "brave",
          icon_preset = "diamond",
        },
      }, --}}}
      ["core.integrations.nvim-cmp"] = {},
      ["core.completion"] = { --{{{
        config = {
          engine = "nvim-cmp",
          name = "[Norg]",
        },
      }, --}}}

      ["core.keybinds"] = { --{{{
        config = {
          hook = function(keybinds)
            keybinds.remap_event("norg", "n", "]]", "core.integrations.treesitter.next.heading")
            keybinds.remap_event("norg", "n", "[[", "core.integrations.treesitter.previous.heading")
          end,
        },
      }, --}}}
      ["core.journal"] = { --{{{
        config = {
          workspace = "home",
          strategy = "flat",
        },
      }, --}}}
      ["core.export"] = {},
      ["core.export.markdown"] = {},
      ["core.qol.toc"] = {},
      ["core.qol.todo_items"] = {},
      ["core.integrations.treesitter"] = {},
    },
  },

  cond = require("config.util").should_start("nvim-neorg/neorg"),
  enabled = require("config.util").is_enabled("nvim-neorg/neorg"),
}

-- vim: fdm=marker fdl=0
