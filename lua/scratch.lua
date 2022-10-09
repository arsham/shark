local quick = require("arshlib.quick")

local store = {}
__Scratch_buffer_storage = __Scratch_buffer_storage or {}
store = __Scratch_buffer_storage

function store.next()
  local i = 1
  while true do
    if not store[i] then
      store[i] = true
      return i
    end
    i = i + 1
  end
end

function store.delete(id)
  store[id] = nil
end

local function new_scratch_buffer()
  local name = string.format("Scratch %d", store.next())
  vim.cmd.vsplit()
  vim.cmd.enew()
  vim.cmd.file(name)
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false

  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = 0,
    callback = function(args)
      local num = tonumber(args.file:match("Scratch (%d+)"))
      store.delete(num)
    end,
  })
end

quick.command("Scratch", function()
  new_scratch_buffer()
end)

return {
  new_scratch_buffer = new_scratch_buffer,
}
