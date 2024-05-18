local spec = {
  teh = "the",
  Teh = "The",
}
local fn = function(term, abbr)
  vim.cmd.iabbrev(term, abbr)
end
if vim.fn.has("nvim-0.10.0") == 1 then
  fn = function(term, abbr)
    vim.keymap.set("ia", term, abbr)
  end
end
vim.schedule(function()
  for term, abbr in pairs(spec) do
    fn(term, abbr)
  end
end)
