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
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          { "on_complete_notify", system = "unfocused" },
          "on_complete_dispose",
        },
        default_neotest = {
          "unique",
          { "on_complete_notify", system = "unfocused", on_change = true },
          "default",
        },
      },
    },
    config = function(_, opts)
      vim.g.overseer_started = true
      local overseer = require("overseer")
      overseer.setup(opts)
    end,

    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerRunCmd",
    },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle tasks" },
    },
    enabled = require("config.util").is_enabled("stevarc/overseer.nvim"),
  },
}
