return {
  "j-hui/fidget.nvim",
  event = { "LspAttach" },
  opts = {
    text = {
      spinner = {
        "⊚∙∙∙∙",
        "∙⊚∙∙∙",
        "∙∙⊚∙∙",
        "∙∙∙⊚∙",
        "∙∙∙∙⊚",
        "∙∙∙⊚∙",
        "∙∙⊚∙∙",
        "∙⊚∙∙∙",
      },
      done = "✔",
      commenced = "Started",
      completed = "Completed",
    },
    window = {
      relative = "editor",
      blend = 0,
    },
    fmt = {
      stack_upwards = false,
      fidget = function(fidget_name, spinner)
        return string.format("%s %s", spinner, fidget_name)
      end,
      -- function to format each task line
      task = function(task_name, message, percentage)
        if task_name and task_name:find("cargo.+clippy") then
          -- checkOnSave shows a very long text each time.
          task_name = "Clippy"
        end
        return string.format(
          "%s%s [%s]",
          message,
          percentage and string.format(" (%s%%)", percentage) or "",
          task_name
        )
      end,
    },
  },
  cond = require("config.util").should_start("j-hui/fidget.nvim"),
  enabled = require("config.util").is_enabled("j-hui/fidget.nvim"),
}
