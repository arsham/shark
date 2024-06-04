return {
  name = "Run Integration Tests",
  builder = function()
    return {
      cmd = [[set -o pipefail; nice -n 15 go test -test.fullpath -tags integration ./... | rg -v "no test files"]],
      name = "Integration",
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
  priority = 20,
  condition = {
    filetype = { "go", "gomod" },
  },
}
