return {
  "ralismark/opsort.vim",
  init = function()
    vim.g.opsort_no_mappings = true
  end,
  config = function()
    vim.keymap.set("x", "gso", "<plug>Opsort", { silent = true })
    vim.keymap.set("n", "gso", "<plug>Opsort", { silent = true })
    vim.keymap.set("n", "gsoo", "<plug>OpsortLines", { silent = true })
  end,
  event = { "BufReadPost", "BufNewFile", "InsertEnter" },
}
