return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  keys = {
    { mode = { "n" }, "<leader>ce", ":Copilot enable<CR>", { silent = true } },
    { mode = { "n" }, "<leader>cd", ":Copilot disable<CR>", { silent = true } },
    { mode = { "n" }, "<leader>cp", ":Copilot panel<CR>", { silent = true } },
  },
  opts = {
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_next = "]]",
        jump_prev = "[[",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
      layout = {
        position = "right",
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<C-y><C-y>",
        accept_word = "<C-y><C-w>",
        accept_line = "<C-y><C-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      gitcommit = true,
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
          -- disable for .env files
          return false
        end
        return true
      end,
    },
    copilot_node_command = "node",
    server_opts_overrides = {
      settings = {
        advanced = {
          inlineSuggestCount = 10,
        },
      },
    },
  },

  cond = require("config.util").should_start("zbirenbaum/copilot.lua"),
  enabled = require("config.util").is_enabled("zbirenbaum/copilot.lua"),
}
