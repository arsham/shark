return {
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = {
        "terminal",
        use_shell = true,
      },
      form = {
        border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
      },
      task_list = { direction = "right" },
      templates = { "builtin", "global" },
    },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
    },
    enabled = require("config.util").is_enabled("stevarc/overseer.nvim"),
  },
}
