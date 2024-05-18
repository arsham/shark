return {
  "j-hui/fidget.nvim",
  event = { "LspAttach" },
  opts = {
    progress = {
      display = {
        format_message = function(msg)
          if string.find(msg.title, "Indexing") then
            return nil -- Ignore "Indexing..." progress messages
          end
          if msg.message then
            return msg.message
          else
            return msg.done and "Completed" or "In progress..."
          end
        end,
      },
    },

    notification = {
      view = {
        stack_upwards = false, -- Display notification items from bottom to top
      },

      window = {
        relative = "editor",
        winblend = 0,
      },
    },
  },
  enabled = require("config.util").is_enabled("j-hui/fidget.nvim"),
}
