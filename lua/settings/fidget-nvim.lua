require("fidget").setup({
  text = {
    spinner = {
      "∙∙∙∙∙∙",
      "●∙∙∙∙∙",
      "∙●∙∙∙∙",
      "∙∙●∙∙∙",
      "∙∙∙●∙∙",
      "∙∙∙∙●∙",
      "∙∙∙∙∙●",
      "∙∙∙∙∙∙",
    },
    done = "✔",
    commenced = "Started",
    completed = "Completed",
  },
  fmt = {
    fidget = function(fidget_name, spinner)
      return string.format("%s %s", spinner, fidget_name)
    end,
    -- function to format each task line
    task = function(task_name, message, percentage)
      return string.format(
        "%s%s [%s]",
        message,
        percentage and string.format(" (%s%%)", percentage) or "",
        task_name
      )
    end,
  },
})
