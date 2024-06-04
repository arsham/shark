return {
  name = "Test cache cleanup",
  builder = function()
    return {
      cmd = { "go" },
      args = { "clean", "-testcache" },
      name = "Cleanup",
      components = {
        { "on_complete_dispose", timeout = 5 },
        "on_exit_set_status",
        "on_complete_notify",
      },
    }
  end,
  tags = { require("overseer").TAG.CLEAN },
  priority = 50,
  condition = {
    filetype = { "go", "gomod" },
  },
}
