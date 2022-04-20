local nvim = require("nvim")

return {
  setup = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
  end,

  config = function()
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>ce", function()
      nvim.ex.Copilot("enable")
      vim.keymap.set("i", "<C-y>", [[copilot#Accept("")]],
      { silent = true, expr = true, script = true, desc = "copilot accept suggestion" })
    end, { silent = true, desc = "enable copilot" })

    vim.keymap.set("n", "<leader>cd", function()
      nvim.ex.Copilot("disable")
      vim.keymap.del("i", "<C-y>")
    end, { silent = true, desc = "disable copilot" })
    -- stylua: ignore end

    -- disabled by default
    nvim.ex.Copilot("disable")
  end,
}
