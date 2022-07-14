vim.keymap.set("n", "<leader>oo", function() --{{{
  vim.keymap.set("n", "<leader>oo", ":Neorg workspace home<CR>")
  vim.api.nvim_command("vert new | Neorg workspace home")
end, { desc = "load Neorg" })
--}}}

-- Mappings {{{
vim.keymap.set("n", "<leader>oh", ":Neorg workspace home<CR>")
vim.keymap.set("n", "<leader>ow", ":Neorg workspace <TAB>")
vim.keymap.set("n", "<leader>ov", ":Neorg keybind norg core.gtd.base.views<CR>")
vim.keymap.set("n", "<leader>oc", ":Neorg keybind norg core.gtd.base.capture<CR>")
--}}}

require("neorg").setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = { --{{{
      config = {
        autochdir = false,
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
    ["core.gtd.base"] = { --{{{
      config = {
        workspace = "home",
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
          keybinds.remap_event("norg", "n", "<leader>oc", "core.gtd.base.capture")
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
  },
})

-- vim: fdm=marker fdl=0
