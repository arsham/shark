local augroup = require("config.util").augroup

-- Highlight Yanks {{{
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("HIGHLIGHT_YANKS"),
  desc = "Highlihgt yanking",
  callback = function()
    vim.highlight.on_yank({ higroup = "Substitute", timeout = 300 })
  end,
}) --}}}

-- Line Return {{{
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("LINE_RETURN"),
  desc = "Auto line return",
  callback = function()
    vim.api.nvim_create_autocmd("FileType", {
      buffer = 0,
      once = true,
      callback = function()
        local types = {
          "nofile",
          "fugitive",
          "gitcommit",
          "gitrebase",
          "commit",
          "rebase",
        }
        if vim.fn.expand("%") == "" then
          return
        end

        for _, item in pairs(types) do
          if item == vim.bo.filetype then
            return
          end
        end
        local line = vim.fn.line

        if line([['"]]) > 0 and line([['"]]) <= line("$") then
          pcall(vim.cmd.normal, { [[g`"zv']], bang = true })
        end
      end,
    })
  end,
}) --}}}

-- No Undo Files {{{
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("NO_UNDO_FILES"),
  pattern = { "COMMIT_EDITMSG", "MERGE_MSG", "gitcommit", "*.tmp", "*.log" },
  callback = function()
    vim.bo.undofile = false
  end,
}) --}}}

-- vim: fdm=marker fdl=0
