return {
  name = "Run Golangci",
  builder = function()
    return {
      cmd = { "nice" },
      args = { "-n", "10", "golangci-lint", "run", "./..." },
      name = "Golangci",
      components = {
        { "display_duration", detail_level = 2 },
        "on_exit_set_status",
        { "on_complete_notify", statuses = { "FAILURE" } },
        "restart_on_save",

        {
          "on_output_parse",
          parser = {
            {
              "extract",
              "^([^:]+):([0-9]+):([0-9]+):",
              "filename",
              "lnum",
              "col",
            },
          },
        },

        { "on_output_quickfix", items_only = true, set_diagnostics = true },
        "on_output_summarize",
      },
    }
  end,
  tags = { require("overseer").TAG.BUILD },
  priority = 10,
  condition = {
    filetype = { "go", "gomod" },
  },
}
