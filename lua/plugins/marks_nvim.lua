return {
  "chentoast/marks.nvim",
  event = { "VeryLazy" },
  config = function()
    local marks = require("marks")
    marks.setup({
      cyclic = true,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },

      bookmark_0 = { sign = "⚑", virt_text = "Bookmark Group (0)" },
      bookmark_1 = { sign = "", virt_text = "Bookmark Group (1)" },
      bookmark_2 = { sign = "", virt_text = "Bookmark Group (2)" },
      bookmark_3 = { sign = "", virt_text = "Bookmark Group (3)" },
      bookmark_4 = { sign = "", virt_text = "Bookmark Group (4)" },
      bookmark_5 = { sign = "", virt_text = "Bookmark Group (5)" },
      bookmark_6 = { sign = "", virt_text = "Bookmark Group (6)" },
      bookmark_7 = { sign = "", virt_text = "Bookmark Group (7)" },
      bookmark_8 = { sign = "", virt_text = "Bookmark Group (8)" },
      bookmark_9 = { sign = "", virt_text = "Bookmark Group (9)" },

      mappings = {
        toggle = "m<space>",
        delete_line = "dm-",
        delete_buf = "dm<Space>",
        set_next = "m,",
        next = "]m",
        prev = "[m",
        preview = false,
        set_bookmark0 = "m0",
      },
    })

    require("arshlib.quick").command("MarksAnnotate", function()
      marks.annotate()
    end)
  end,
}
