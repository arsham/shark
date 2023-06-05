return {
  "jbyuki/venn.nvim",
  keys = {
    {
      mode = "n",
      "<leader>v",
      function()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.opt_local.ve = "all"
          vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true })
          vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true })
          vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true })
          vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true })
          vim.keymap.set("x", "f", ":VBox<CR>", { buffer = true })
          vim.keymap.set("x", "F", ":VBoxH<CR>", { buffer = true })
          vim.keymap.set("x", "o", ":VBoxO<CR>", { buffer = true })
          vim.keymap.set("x", "d", ":VBoxD<CR>", { buffer = true })
          return
        end

        vim.opt_local.ve = ""
        vim.cmd.mapclear("<buffer>")
        vim.b.venn_enabled = nil
      end,
    },
  },
  enabled = require("config.util").is_enabled("jbyuki/venn.nvim"),
}
