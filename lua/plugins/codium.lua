return {
  "Exafunction/codeium.vim",
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
  keys = {
    { mode = { "n" }, "<leader>ce", ":Codeium Enable<CR>", { silent = true } },
    { mode = { "n" }, "<leader>cd", ":Codeium Disable<CR>", { silent = true } },
  },
  config = function()
    -- stylua: ignore start
    vim.keymap.set("i", "<C-y>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
    vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
    vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
    vim.keymap.set("i", "<C-e>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
    -- stylua: ignore end
  end,

  -- Their mappings are overlapping therefore if copilot is active, codeium is
  -- not.
  cond = function()
    if require("config.util").should_start("zbirenbaum/copilot.lua") then
      return false
    end
    return require("config.util").should_start("Exafunction/codeium.vim")
  end,
  enabled = function()
    if require("config.util").is_enabled("zbirenbaum/copilot.lua") then
      return false
    end
    return require("config.util").is_enabled("Exafunction/codeium.vim")
  end,
}
