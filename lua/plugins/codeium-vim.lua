return {
  "Exafunction/codeium.vim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_filetypes = {
      rust = true,
      go = true,
      lua = true,
      markdown = true,
      norg = true,
      zsh = true,
      bash = true,
      txt = true,
      js = true,
    }
  end,
  cmd = { "Codeium" },
  -- stylua: ignore
  keys = {
    { mode = { "n" }, "<leader>ce", function()
      vim.cmd.Codeium("Enable")
      vim.keymap.set("i", "<C-y><c-y>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
      vim.keymap.set("i", "<M-]>",      function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
      vim.keymap.set("i", "<M-[>",      function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
      vim.keymap.set("i", "<C-e>",      function() return vim.fn["codeium#Clear"]() end, { expr = true })

      vim.keymap.set("n", "<leader>cd", function()
        vim.keymap.del("i", "<C-y><c-y>")
        vim.keymap.del("i", "<M-]>")
        vim.keymap.del("i", "<M-[>")
        vim.keymap.del("i", "<C-e>")
        vim.cmd.Codeium("Disable")
        vim.keymap.del("n", "<leader>cd")
      end, { silent = true })
    end, { silent = true } },
  },
  config = function()
  end,

  -- Their mappings are overlapping therefore if copilot is active, codeium is
  -- not.
  cond = function()
    if require("config.util").should_start("zbirenbaum/copilot.lua")() then
      return false
    end
    return require("config.util").should_start()
  end,
  enabled = require("config.util").is_enabled("Exafunction/codeium.vim"),
}
