return {
  name = "Run Unit Tests",
  builder = function()
    return {
      cmd = [[set -o pipefail; nice -n 15 go test -test.fullpath ./... | rg -v "no test files"]],
      name = "Unit test",
      components = {
        { "display_duration", detail_level = 2 },
        "on_exit_set_status",
        { "on_complete_notify", statuses = { "FAILURE" } },
        "restart_on_save",

        {
          "on_output_quickfix",
          items_only = true,
          set_diagnostics = true,
          errorformat = require("config.errorformats").go_with_testify,
        },

        "on_output_summarize",
      },
    }
  end,
  tags = { require("overseer").TAG.TEST },
  priority = 10,
  condition = {
    filetype = { "go", "gomod" },
  },
}
