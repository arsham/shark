return {
  name = "Run Go Generate",
  builder = function()
    return {
      cmd = { "go" },
      args = { "generate", "./..." },
      name = "Generate",
      components = {
        { "on_complete_dispose", timeout = 30 },
        "on_exit_set_status",
        "on_complete_notify",
      },
    }
  end,
  tags = { require("overseer").TAG.TEST },
  priority = 20,
  condition = {
    filetype = { "go", "gomod" },
  },
}
