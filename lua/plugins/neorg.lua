vim.api.nvim_create_autocmd("FileType", { -- {{{
  once = true,
  pattern = { "norg" },
  callback = function()
    vim.api.nvim_create_user_command("Journal", ":Neorg journal", {})
    vim.keymap.set("n", "<localleader>nr", ":Neorg return<CR>", { buffer = true })
    require("arshlib.quick").command("NG", function(args)
      require("neorg.modules.core.neorgcmd.module").public.function_callback(unpack(args.fargs))
    end, { nargs = "*", complete = "customlist,v:lua._neorgcmd_generate_completions" })


}) -- }}}

return {
  "nvim-neorg/neorg",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
  },
  build = ":Neorg sync-parsers",
  cmd = { "Neorg" },
  keys = {
    { mode = "n", "<leader>nh", ":Neorg workspace home<CR>" },
    { mode = "n", "<leader>nw", ":Neorg workspace <TAB>" },
    { mode = "n", "<leader>nj", ":Neorg journal<CR>" },
    { mode = "n", "<leader>ni", ":Neorg index<CR>" },
  },
  cond = require("util").full_start_with_lsp,

  opts = {
    lazy_loading = false,
    load = {
      ["core.defaults"] = {},
      ["core.norg.dirman"] = { --{{{
        config = {
          autochdir = false,
          autodetect = false,
          autochdetect = true,
          workspaces = {
            home = "~/Dropbox/Notes",
          },
        },
      }, --}}}
      ["core.norg.concealer"] = { --{{{
        config = {
          markup_preset = "brave",
        },
      }, --}}}
      ["core.integrations.nvim-cmp"] = {},
      ["core.norg.completion"] = { --{{{
        config = {
          engine = "nvim-cmp",
        },
      }, --}}}

      ["core.keybinds"] = { --{{{
        config = {
          hook = function(keybinds)
            local leader = keybinds.leader
            keybinds.remap_key("norg", "n", leader .. "tv", "<leader>ov")
            keybinds.remap_event("norg", "n", "]]", "core.integrations.treesitter.next.heading")
            keybinds.remap_event("norg", "n", "[[", "core.integrations.treesitter.previous.heading")
          end,
        },
      }, --}}}
      ["core.norg.journal"] = { --{{{
        config = {
          workspace = "home",
          strategy = "flat",
        },
      }, --}}}
      ["core.export"] = {},
      ["core.export.markdown"] = {},
      ["core.norg.qol.toc"] = {},
    },
  },
}

-- vim: fdm=marker fdl=0
