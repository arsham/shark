local function config()
  require("arshlib.quick").command("NG", function(args) --{{{
    require("neorg.modules.core.neorgcmd.module").public.function_callback(unpack(args.fargs))
  end, { nargs = "*", complete = "customlist,v:lua._neorgcmd_generate_completions" })
  --}}}

  vim.keymap.set("n", "<leader>oo", function() --{{{
    vim.keymap.set("n", "<leader>oo", ":Neorg workspace home<CR>")
    vim.api.nvim_command("vert new | Neorg workspace home")
  end, { desc = "load Neorg" })
  --}}}

  -- Mappings {{{
  vim.keymap.set("n", "<leader>oh", ":Neorg workspace home<CR>")
  vim.keymap.set("n", "<leader>ow", ":Neorg workspace <TAB>")
  --}}}

  vim.api.nvim_create_user_command("Journal", ":Neorg journal", {})

  require("neorg").setup({
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
            keybinds.remap_key("norg", "n", "gtd", "<leader>od")
            keybinds.remap_key("norg", "n", "gtu", "<leader>ou")
            keybinds.remap_key("norg", "n", "gtp", "<leader>op")
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
  })
end

return {
  "nvim-neorg/neorg",
  config = config,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
  },
  build = ":Neorg sync-parsers",
  cmd = { "NeorgStart" },
  keys = { "<leader>oo" },
  cond = require("util").full_start_with_lsp,
}

-- vim: fdm=marker fdl=0
