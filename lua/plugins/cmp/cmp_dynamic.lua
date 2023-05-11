return {
  "uga-rosa/cmp-dynamic",
  lazy = true,
  config = function()
    local Date = require("cmp_dynamic.utils.date")
    require("cmp_dynamic").register({
      {
        label = "today",
        insertText = function()
          return os.date("%Y/%m/%d")
        end,
      },
      {
        label = "yesterday",
        resolve = true,
        insertText = function()
          return Date.new():add_date(-1):day(1):format("%Y/%m/%d")
        end,
      },
    })
  end,
}
